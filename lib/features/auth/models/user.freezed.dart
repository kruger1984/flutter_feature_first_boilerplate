// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

@JsonKey(fromJson: _idFromJson) int? get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get phone;@JsonKey(name: 'name') String get nickname; String get language; String get avatar; String get about; String get email; String get timezone;@JsonKey(fromJson: _tryParseDate) DateTime? get birthday;@JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal) DateTime? get lastRethinkAt;@JsonKey(name: 'show_review') bool get showRethink; Subscription? get subscription;@JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable) DateTime? get updatedAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.language, language) || other.language == language)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.about, about) || other.about == about)&&(identical(other.email, email) || other.email == email)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.lastRethinkAt, lastRethinkAt) || other.lastRethinkAt == lastRethinkAt)&&(identical(other.showRethink, showRethink) || other.showRethink == showRethink)&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,phone,nickname,language,avatar,about,email,timezone,birthday,lastRethinkAt,showRethink,subscription,createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, nickname: $nickname, language: $language, avatar: $avatar, about: $about, email: $email, timezone: $timezone, birthday: $birthday, lastRethinkAt: $lastRethinkAt, showRethink: $showRethink, subscription: $subscription, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) int? id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String phone,@JsonKey(name: 'name') String nickname, String language, String avatar, String about, String email, String timezone,@JsonKey(fromJson: _tryParseDate) DateTime? birthday,@JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal) DateTime? lastRethinkAt,@JsonKey(name: 'show_review') bool showRethink, Subscription? subscription,@JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable) DateTime? updatedAt
});


$SubscriptionCopyWith<$Res>? get subscription;

}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? firstName = null,Object? lastName = null,Object? phone = null,Object? nickname = null,Object? language = null,Object? avatar = null,Object? about = null,Object? email = null,Object? timezone = null,Object? birthday = freezed,Object? lastRethinkAt = freezed,Object? showRethink = null,Object? subscription = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRethinkAt: freezed == lastRethinkAt ? _self.lastRethinkAt : lastRethinkAt // ignore: cast_nullable_to_non_nullable
as DateTime?,showRethink: null == showRethink ? _self.showRethink : showRethink // ignore: cast_nullable_to_non_nullable
as bool,subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as Subscription?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<$Res>? get subscription {
    if (_self.subscription == null) {
    return null;
  }

  return $SubscriptionCopyWith<$Res>(_self.subscription!, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  int? id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String phone, @JsonKey(name: 'name')  String nickname,  String language,  String avatar,  String about,  String email,  String timezone, @JsonKey(fromJson: _tryParseDate)  DateTime? birthday, @JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal)  DateTime? lastRethinkAt, @JsonKey(name: 'show_review')  bool showRethink,  Subscription? subscription, @JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.phone,_that.nickname,_that.language,_that.avatar,_that.about,_that.email,_that.timezone,_that.birthday,_that.lastRethinkAt,_that.showRethink,_that.subscription,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  int? id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String phone, @JsonKey(name: 'name')  String nickname,  String language,  String avatar,  String about,  String email,  String timezone, @JsonKey(fromJson: _tryParseDate)  DateTime? birthday, @JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal)  DateTime? lastRethinkAt, @JsonKey(name: 'show_review')  bool showRethink,  Subscription? subscription, @JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.firstName,_that.lastName,_that.phone,_that.nickname,_that.language,_that.avatar,_that.about,_that.email,_that.timezone,_that.birthday,_that.lastRethinkAt,_that.showRethink,_that.subscription,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  int? id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String phone, @JsonKey(name: 'name')  String nickname,  String language,  String avatar,  String about,  String email,  String timezone, @JsonKey(fromJson: _tryParseDate)  DateTime? birthday, @JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal)  DateTime? lastRethinkAt, @JsonKey(name: 'show_review')  bool showRethink,  Subscription? subscription, @JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.phone,_that.nickname,_that.language,_that.avatar,_that.about,_that.email,_that.timezone,_that.birthday,_that.lastRethinkAt,_that.showRethink,_that.subscription,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({@JsonKey(fromJson: _idFromJson) this.id, @JsonKey(name: 'first_name') this.firstName = '', @JsonKey(name: 'last_name') this.lastName = '', this.phone = '', @JsonKey(name: 'name') this.nickname = '', this.language = 'en', this.avatar = '', this.about = '', this.email = '', this.timezone = 'UTC', @JsonKey(fromJson: _tryParseDate) this.birthday, @JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal) this.lastRethinkAt, @JsonKey(name: 'show_review') this.showRethink = false, this.subscription, @JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable) this.updatedAt}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  int? id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey() final  String phone;
@override@JsonKey(name: 'name') final  String nickname;
@override@JsonKey() final  String language;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  String about;
@override@JsonKey() final  String email;
@override@JsonKey() final  String timezone;
@override@JsonKey(fromJson: _tryParseDate) final  DateTime? birthday;
@override@JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal) final  DateTime? lastRethinkAt;
@override@JsonKey(name: 'show_review') final  bool showRethink;
@override final  Subscription? subscription;
@override@JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable) final  DateTime? updatedAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.language, language) || other.language == language)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.about, about) || other.about == about)&&(identical(other.email, email) || other.email == email)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.lastRethinkAt, lastRethinkAt) || other.lastRethinkAt == lastRethinkAt)&&(identical(other.showRethink, showRethink) || other.showRethink == showRethink)&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,phone,nickname,language,avatar,about,email,timezone,birthday,lastRethinkAt,showRethink,subscription,createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, nickname: $nickname, language: $language, avatar: $avatar, about: $about, email: $email, timezone: $timezone, birthday: $birthday, lastRethinkAt: $lastRethinkAt, showRethink: $showRethink, subscription: $subscription, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) int? id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String phone,@JsonKey(name: 'name') String nickname, String language, String avatar, String about, String email, String timezone,@JsonKey(fromJson: _tryParseDate) DateTime? birthday,@JsonKey(name: 'last_review_at', fromJson: _tryParseDateLocal) DateTime? lastRethinkAt,@JsonKey(name: 'show_review') bool showRethink, Subscription? subscription,@JsonKey(name: 'created_at', fromJson: _parseDateLocalNullable) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _parseDateLocalNullable) DateTime? updatedAt
});


@override $SubscriptionCopyWith<$Res>? get subscription;

}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? firstName = null,Object? lastName = null,Object? phone = null,Object? nickname = null,Object? language = null,Object? avatar = null,Object? about = null,Object? email = null,Object? timezone = null,Object? birthday = freezed,Object? lastRethinkAt = freezed,Object? showRethink = null,Object? subscription = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AppUser(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRethinkAt: freezed == lastRethinkAt ? _self.lastRethinkAt : lastRethinkAt // ignore: cast_nullable_to_non_nullable
as DateTime?,showRethink: null == showRethink ? _self.showRethink : showRethink // ignore: cast_nullable_to_non_nullable
as bool,subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as Subscription?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<$Res>? get subscription {
    if (_self.subscription == null) {
    return null;
  }

  return $SubscriptionCopyWith<$Res>(_self.subscription!, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}

// dart format on
