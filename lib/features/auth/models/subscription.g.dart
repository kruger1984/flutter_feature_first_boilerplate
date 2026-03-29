// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      productId: json['product_id'] as String,
      expiredAt: _expiredAtFromJson(json['expired_at']),
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'expired_at': instance.expiredAt.toIso8601String(),
    };
