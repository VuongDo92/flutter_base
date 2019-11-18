import 'dart:async';

import 'providers/providers.dart';

class AuthenticateRepository {
  final _events = StreamController<AuthenticateEvent>.broadcast();
  Stream<AuthenticateEvent> get events => _events.stream;

  String _akamaiClientId;
  String _akamaiAuthorizationEndpoint;
  String _akamaiTokenEndpoint;
  String _akamaiRedirectURL;
  String _akamaiSchemeURL;
  var _akamaiScopes;

  String get akamaiClientId => _akamaiClientId;
  String get akamaiAuthorizationEndpoint => _akamaiAuthorizationEndpoint;
  String get akamaiTokenEndpoint => _akamaiTokenEndpoint;
  String get akamaiRedirectURL => _akamaiRedirectURL;
  String get akamaiSchemeURL => _akamaiSchemeURL;
  get akamaiScopes => _akamaiScopes;

  String _accessToken;
  String _refreshToken;
  String _idToken;

  String _sessionToken;
  dynamic _account;
  String _deviceId;

  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get idToken => _idToken;

  String get sessionToken => _sessionToken;
  dynamic get account => _account;
  String get deviceId => _deviceId;

  RemoteApiProvider _remoteApiProvider;
  ApiProvider _apiProvider;
  SecretProvider _secretProvider;
  LocalStorageProvider _localStorageProvider;

  AuthenticateRepository(this._remoteApiProvider, this._apiProvider,
      this._secretProvider, this._localStorageProvider) {
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

  Future<dynamic> authenticate() {}

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

  Future<void> saveToken(
      String accessToken, String refreshToken, String idToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _idToken = idToken;

//    return _secretProvider.saveAkamaiToken(accessToken, refreshToken, idToken);
  }
}

abstract class AuthenticateEvent {}

class LoggedOutEvent extends AuthenticateEvent {}

class LoggedInEvent extends AuthenticateEvent {}
