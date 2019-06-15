import 'package:flutter/services.dart';

typedef CallHandler = Future<dynamic> Function(MethodCall call);

class PlatformChannel {
//  static const _CHANNEL_NAME = 'com.rovo.rovo';
//  static final _channel = const MethodChannel(_CHANNEL_NAME);
//
//  PlatformChannel(CallHandler callHandler) {
//    _channel.setMethodCallHandler(callHandler);
//  }
//
//  Future<bool> applyFirebaseActionCode(String oobCode) => _channel
//      .invokeMethod<bool>('FIREBASE_APPLY_ACTION_CODE', {'oobCode': oobCode});
//
//  Future<bool> confirmFirebasePasswordReset(
//          String oobCode, String newPassword) =>
//      _channel.invokeMethod<bool>('FIREBASE_PASSWORD_RESET',
//          {'oobCode': oobCode, 'newPassword': newPassword});
//
//  Future<String> getDeviceUUID() =>
//      _channel.invokeMethod<String>('GET_DEVICE_UUID');
//
//  Future<String> getShortUrl(
//    BranchUniversalObject buo,
//    BranchLinkProperties lp,
//  ) {
//    return _channel.invokeMethod<String>('GET_SHORT_BRANCH_URL', {
//      'buo': buo.toJson(),
//      'lp': lp.toJson(),
//    });
//  }
//
//  Future showBuoShareSheet(
//    BranchUniversalObject buo,
//    BranchLinkProperties lp,
//  ) {
//    return _channel.invokeMethod<String>('SHOW_BUO_SHARE_SHEET', {
//      'buo': buo.toJson(),
//      'lp': lp.toJson(),
//    });
//  }
}
