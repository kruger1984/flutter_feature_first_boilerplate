import 'package:easy_localization/easy_localization.dart';
import 'package:zvychka/api/zvychka/client.dart';
import 'package:zvychka/helpers/function.dart';
import 'package:zvychka/models/user.dart';
import 'package:zvychka/services/auth.dart';

class ApiUser extends Api {
  static Future<String> loginBySocialToken(String provider, String token) async {
    Map<String, String> queryParams = {'provider': provider, 'token': token};

    final response = await Api.get(method: "social-auth/$provider/callback", queryParameters: queryParams);

    return response['token'];
  }

  static Future<User> update({
    String? nickname,
    String? fcmToken,
    String? timeZone,
    String? language,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
    DateTime? birthday,
    DateTime? rethinkedAt,
    String? about,
  }) async {
    Map<String, String> queryParams = {};

    if (language != null) {
      queryParams['language'] = language;
    }

    if (nickname != null) {
      queryParams['nickname'] = nickname;
    }
    if (phone != null) {
      queryParams['phone'] = phone;
    }
    if (timeZone != null) {
      queryParams['timezone'] = timeZone;
    }

    if (firstName != null) {
      queryParams['first_name'] = firstName;
    }

    if (lastName != null) {
      queryParams['last_name'] = lastName;
    }

    if (fcmToken != null) {
      queryParams['fcm_token'] = fcmToken;
    }

    if (avatar != null) {
      queryParams['avatar'] = avatar;
    }
    if (birthday != null) {
      queryParams['birthday'] = DateFormat('yyyy-MM-dd').format(birthday);
    }
    if (about != null) {
      queryParams['about'] = about;
    }
    if (rethinkedAt != null) {
      queryParams['last_review_at'] = formatDate(rethinkedAt)!;
    }

    final response = await Api.put(method: "profile/${Auth.user().id}", queryParameters: queryParams);
    return User.fromJson(response['item']);
  }

  static Future<User> get() async {
    final response = await Api.get(method: "profile");

    // return response['token'];
    final item = response['item'];
    return User.fromJson(item);
  }

  static Future<void> delete() async {
    await Api.delete(method: "users/${Auth.user().id}");
  }
}
