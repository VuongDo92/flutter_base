// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'akamai_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$AkamaiStore on _AkamaiStore, Store {
  final _$isBusyWithAkamaiAtom = Atom(name: '_AkamaiStore.isBusyWithAkamai');

  @override
  bool get isBusyWithAkamai {
    _$isBusyWithAkamaiAtom.context.enforceReadPolicy(_$isBusyWithAkamaiAtom);
    _$isBusyWithAkamaiAtom.reportObserved();
    return super.isBusyWithAkamai;
  }

  @override
  set isBusyWithAkamai(bool value) {
    _$isBusyWithAkamaiAtom.context.conditionallyRunInAction(() {
      super.isBusyWithAkamai = value;
      _$isBusyWithAkamaiAtom.reportChanged();
    }, _$isBusyWithAkamaiAtom, name: '${_$isBusyWithAkamaiAtom.name}_set');
  }

  final _$akamaiAuthorizeAsyncAction = AsyncAction('akamaiAuthorize');

  @override
  Future<dynamic> akamaiAuthorize() {
    return _$akamaiAuthorizeAsyncAction.run(() => super.akamaiAuthorize());
  }

  final _$_AkamaiStoreActionController = ActionController(name: '_AkamaiStore');

  @override
  Future registerDevice({String deviceId, int applicationBadge = null}) {
    final _$actionInfo = _$_AkamaiStoreActionController.startAction();
    try {
      return super.registerDevice(
          deviceId: deviceId, applicationBadge: applicationBadge);
    } finally {
      _$_AkamaiStoreActionController.endAction(_$actionInfo);
    }
  }
}
