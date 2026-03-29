import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../api/zvychka/user.dart';
import '../helpers/log.dart';

class AuthService {
  static const List<String> _scopes = ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email'];

  static Future<String> signInWithGoogle() async {
    Log.i('[AuthService] Google sign-in started');

    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize();

      Log.d('[AuthService] Google SDK initialized');

      final GoogleSignInAccount user = await signIn.authenticate();

      Log.d('[AuthService] Google user authenticated');

      final GoogleSignInClientAuthorization authorization = await user.authorizationClient.authorizeScopes(_scopes);

      final String accessToken = authorization.accessToken;

      Log.v('[AuthService] Google access token received');

      final response = await ApiUser.loginBySocialToken('google', accessToken);

      Log.i('[AuthService] Google login success');

      return response.toString();
    } catch (e, st) {
      Log.e('[AuthService] Google sign-in failed', st);
      rethrow;
    }
  }

  static Future<String> signInWithApple() async {
    Log.i('[AuthService] Apple sign-in started');

    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      final identityToken = appleCredential.identityToken;
      if (identityToken == null) {
        throw Exception('Apple identityToken is null');
      }

      Log.d('[AuthService] Apple identity token received');

      final response = await ApiUser.loginBySocialToken('apple', identityToken);

      Log.i('[AuthService] Apple login success');
      return response.toString();
    } catch (e, st) {
      Log.e('[AuthService] Apple sign-in failed', st);
      rethrow;
    }
  }

  static String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
