import 'package:feature_first_example/features/auth/models/auth_session.dart';
import 'package:feature_first_example/features/auth/providers/auth_session_revision_pod.dart';
import 'package:feature_first_example/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<AuthSession?> build() async {
    ref.watch(authSessionRevisionProvider);
    return ref.read(authRepositoryProvider).restoreSession();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(email: email, password: password);
    });
  }

   Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).loginWithGoogle();
    });
  }

  Future<void> loginWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).loginWithApple();
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }

}

@riverpod
AppUser? currentUser(Ref ref) {
  return ref.watch(authProvider).value?.user;
}
