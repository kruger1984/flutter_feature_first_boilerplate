// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: _idFromJson(json['id']),
  firstName: json['first_name'] as String? ?? '',
  lastName: json['last_name'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  nickname: json['name'] as String? ?? '',
  language: json['language'] as String? ?? 'en',
  avatar: json['avatar'] as String? ?? '',
  about: json['about'] as String? ?? '',
  email: json['email'] as String? ?? '',
  timezone: json['timezone'] as String? ?? 'UTC',
  birthday: _tryParseDate(json['birthday']),
  lastRethinkAt: _tryParseDateLocal(json['last_review_at']),
  showRethink: json['show_review'] as bool? ?? false,
  subscription: json['subscription'] == null
      ? null
      : Subscription.fromJson(json['subscription'] as Map<String, dynamic>),
  createdAt: _parseDateLocalNullable(json['created_at']),
  updatedAt: _parseDateLocalNullable(json['updated_at']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone': instance.phone,
  'name': instance.nickname,
  'language': instance.language,
  'avatar': instance.avatar,
  'about': instance.about,
  'email': instance.email,
  'timezone': instance.timezone,
  'birthday': instance.birthday?.toIso8601String(),
  'last_review_at': instance.lastRethinkAt?.toIso8601String(),
  'show_review': instance.showRethink,
  'subscription': instance.subscription,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
