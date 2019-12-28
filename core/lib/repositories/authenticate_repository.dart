import 'dart:async';

import 'package:core/utils/uuid.dart';

import 'providers/providers.dart';

class AuthenticateRepository {
  static const String _DEVICE_ID_KEY = "deviceId";

  final _events = StreamController<AuthenticateEvent>.broadcast();
  Stream<AuthenticateEvent> get events => _events.stream;

  String _akamaiClientId;
  String _akamaiAuthorizationEndpoint;
  String _akamaiTokenEndpoint;
  String _akamaiRedirectURL;
  String _akamaiSchemeURL;
  String _akamaiScopes;

  String get akamaiClientId => _akamaiClientId;
  String get akamaiAuthorizationEndpoint => _akamaiAuthorizationEndpoint;
  String get akamaiTokenEndpoint => _akamaiTokenEndpoint;
  String get akamaiRedirectURL => _akamaiRedirectURL;
  String get akamaiSchemeURL => _akamaiSchemeURL;
  List<String> get akamaiScopes {
    List<String> parts = _akamaiScopes.split(RegExp(","));
    return parts.map((it) =>
      it.replaceAll(RegExp('[!@#\$%^&*(),.?"[\\]:{}|<>]'), '').trim()
    ).toList();
  }

  String _sessionToken;
  dynamic _account;
  String _deviceId;

  String get sessionToken => _sessionToken;
  dynamic get account => _account;
  String get deviceId => _deviceId;

  RemoteApiProvider _remoteApiProvider;
  ApiProvider _apiProvider;
  SecretProvider _secretProvider;
  LocalStorageProvider _localStorageProvider;
  PushProvider _pushProvider;

  AuthenticateRepository(this._remoteApiProvider, this._apiProvider,
      this._secretProvider, this._localStorageProvider, this._pushProvider) {
    this.events.listen((event) async {
      if (event is LoggedInEvent) {
      } else if (event is LoggedOutEvent) {}
    });
  }

  Future<void> init() async {
    final data = await this._remoteApiProvider.fetchConfig();
    final akamai = data['akamaiConfigs'];
    this._akamaiScopes = akamai['scopes'];
    this._akamaiClientId = akamai['clientId'];
    this._akamaiRedirectURL = akamai['redirectURL'];
    this._akamaiAuthorizationEndpoint = akamai['authorizationEndpoint'];
    this._akamaiTokenEndpoint = akamai['tokenEndpoint'];
    this._akamaiSchemeURL = akamai['schemeURL'];
  }

  Future<dynamic> authenticateWithAkamai(
      String _accessToken, String _idToken, String _refreshToken) async {
    final result = await _apiProvider.authenticateWithAkamai(
        accessToken: _accessToken,
        idToken: _idToken,
        refreshToken: _refreshToken,
        deviceId: _deviceId);
    return result;
  }

  Future<void> logout() async {
    try {
      await this._apiProvider.logout();
    } catch (e) {
      // ignore
    }
//    await this._localStorageProvider.saveCurrentAccount(null);
    await this._secretProvider.deleteSessionToken();
    this._apiProvider.sessionToken = null;
    _sessionToken = null;
    _account = null;
    _events.add(LoggedOutEvent());
  }

  Future<void> saveSessionToken(String sessionToken) async {
    return _secretProvider.saveSessionToken(sessionToken);
  }

  Future registerDevice({String deviceId, int applicationBadge}) async {
    if (deviceId == null && _deviceId == null) {
      final savedDeviceId =
          await this._localStorageProvider.getString(_DEVICE_ID_KEY);
      deviceId = savedDeviceId;
    } else if (deviceId != null) {
      _deviceId = deviceId;
    }

    if (_deviceId == null) {
      _deviceId = Uuid().generateV4();
      await _localStorageProvider.setString(_DEVICE_ID_KEY, _deviceId);
    }
    _apiProvider.deviceId = _deviceId;
    try {
      await _registerDevice(
        applicationBadge: applicationBadge,
      );
    } catch (e) {
      // ignore
    }
  }

  Future _registerDevice({
    int applicationBadge = null,
  }) {
//    if (_deviceId == null) {
//      return null;
//    }
//    return _apiProvider.registerDevice(
//      pushToken: _pushProvider.pushToken,
//      deviceId: _deviceId,
//      applicationBadge: applicationBadge,
//    );
  }
}

abstract class AuthenticateEvent {}

class LoggedOutEvent extends AuthenticateEvent {}

class LoggedInEvent extends AuthenticateEvent {}
