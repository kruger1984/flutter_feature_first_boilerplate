import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/router_pod.dart';
import '../../../core/utils/talker_pod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/payable_product.dart';
import '../models/payment_enums.dart';
import '../repository/payment_repository.dart';

part 'payment_pod.g.dart';

@Riverpod(keepAlive: true)
class PaymentController extends _$PaymentController {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  FutureOr<List<PayableProduct>> build() async {
    // 1. Налаштовуємо слухача стріму покупок
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        ref.read(talkerProvider).error('Помилка IAP стріму: $error');
      },
    );

    // Гарантуємо, що стрім закриється, якщо провайдер колись знищиться
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // 2. Завантажуємо продукти
    return _loadProducts();
  }

  /// Завантажує продукти з бекенду, а потім отримує їхні ціни з Apple/Google
  Future<List<PayableProduct>> _loadProducts() async {
    final talker = ref.read(talkerProvider);

    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      talker.warning('IAP недоступні на цьому пристрої');
      return [];
    }

    // Отримуємо з бекенду
    final backendProducts = await ref.read(paymentRepositoryProvider).getPurchases(resetCache: true);

    if (backendProducts.isEmpty) return [];

    // Збираємо ID для поточного магазину
    final productIds = backendProducts.map((e) => e.storeId).toSet();

    // Отримуємо ціни зі стору
    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      talker.error('Помилка queryProductDetails: ${response.error}');
      return [];
    }

    // Поєднуємо бекенд і стор в один список
    final List<PayableProduct> payableProducts = [];
    for (final backendProduct in backendProducts) {
      try {
        final storeDetails = response.productDetails.firstWhere((pd) => pd.id == backendProduct.storeId);
        payableProducts.add(PayableProduct(storeProduct: backendProduct, productDetails: storeDetails));
      } catch (_) {
        talker.warning('Стор не повернув продукт: ${backendProduct.storeId}');
      }
    }

    return payableProducts;
  }

  /// Виклик покупки (UI натискає на кнопку)
  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    // Для підписок та невідновлюваних покупок використовується buyNonConsumable
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Відновлення покупок
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e, st) {
      ref.read(talkerProvider).error('Помилка відновлення', e, st);
    }
  }

  /// Головний обробник стріму (заміна старого listener)
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    final talker = ref.read(talkerProvider);
    final repo = ref.read(paymentRepositoryProvider);

    for (var purchase in purchases) {
      talker.debug('IAP Статус: ${purchase.status} | ID: ${purchase.productID}');

      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        try {
          // 1. Валідація на бекенді
          final result = await repo.checkSubscription(productId: purchase.productID, token: purchase.verificationData.serverVerificationData, resetCache: true);

          if (result.status == ValidationStatus.active) {
            talker.info('✅ Купівля успішна та підтверджена сервером!');

            // 2. Оновлюємо дані юзера в додатку
            ref.read(authProvider.notifier).refreshUser();

            // 3. Завершуємо транзакцію в сторі
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }

            // 4. Формуємо повідомлення
            final isRestore = purchase.status == PurchaseStatus.restored;
            final message = isRestore ? 'Покупки успішно відновлено!' : 'Дякуємо за покупку!';

            // 5. Переходимо на екран "Дякуємо" і передаємо туди наше повідомлення через `extra`
            ref.read(routerProvider).go('/payment/thanks', extra: message);

          } else {
            talker.warning('⚠️ Сервер повернув статус: ${result.status}');
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          }
        } catch (e, st) {
          talker.error('❌ Помилка валідації чеку', e, st);
          if (purchase.pendingCompletePurchase) {
            // Навіть якщо наш сервак впав, завершуємо покупку, щоб гроші не повернулися
            await _iap.completePurchase(purchase);
          }
        }
      } else if (purchase.status == PurchaseStatus.canceled || purchase.status == PurchaseStatus.error) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }
}
