// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_revision_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumps when the API returns 401 so [authProvider] rebuilds from storage.

@ProviderFor(AuthSessionRevision)
final authSessionRevisionProvider = AuthSessionRevisionProvider._();

/// Bumps when the API returns 401 so [authProvider] rebuilds from storage.
final class AuthSessionRevisionProvider
    extends $NotifierProvider<AuthSessionRevision, int> {
  /// Bumps when the API returns 401 so [authProvider] rebuilds from storage.
  AuthSessionRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionRevisionHash();

  @$internal
  @override
  AuthSessionRevision create() => AuthSessionRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$authSessionRevisionHash() =>
    r'f30637dcd4c9bbc84c2d7cbcba6481a9453a90e3';

/// Bumps when the API returns 401 so [authProvider] rebuilds from storage.

abstract class _$AuthSessionRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
