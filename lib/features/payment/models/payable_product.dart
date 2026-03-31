import 'package:in_app_purchase/in_app_purchase.dart';
import 'store_product.dart';

/// Обгортка, що поєднує дані з нашого бекенду та дані з Apple/Google Store
class PayableProduct {
  PayableProduct({
    required this.storeProduct,
    required this.productDetails,
  });

  final StoreProduct storeProduct;
  final ProductDetails productDetails;
}