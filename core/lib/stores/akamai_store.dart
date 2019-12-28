import 'package:core/repositories/authenticate_repository.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mobx/mobx.dart';

part 'akamai_store.g.dart';

class AkamaiStore = _AkamaiStore with _$AkamaiStore;

abstract class _AkamaiStore with Store {
  FlutterAppAuth _appAuth;

  final AuthenticateRepository authenticateRepository;

  String get akamaiClientId => authenticateRepository.akamaiClientId;
  String get akamaiAuthorizationEndpoint =>
      authenticateRepository.akamaiAuthorizationEndpoint;
  String get akamaiTokenEndpoint => authenticateRepository.akamaiTokenEndpoint;
  String get akamaiRedirectURL => authenticateRepository.akamaiRedirectURL;
  String get akamaiSchemeURL => authenticateRepository.akamaiSchemeURL;
  get akamaiScopes => authenticateRepository.akamaiScopes;

  _AkamaiStore({this.authenticateRepository}) {
    _appAuth = FlutterAppAuth();
  }

  @observable
  bool isBusyWithAkamai = false;

  @action
  Future akamaiAuthorize() async {
    runInAction(() => this.isBusyWithAkamai = true);
    try {
      final AuthorizationServiceConfiguration _serviceConfiguration =
          AuthorizationServiceConfiguration(
              akamaiAuthorizationEndpoint, akamaiTokenEndpoint);
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(akamaiClientId, akamaiRedirectURL,
            scopes: akamaiScopes,
            serviceConfiguration: _serviceConfiguration,
            promptValues: ['login']),
      );

      if (result != null) {
        var _accessToken = result.accessToken;
        var _idToken = result.idToken;
        var _refreshToken = result.refreshToken;

        return await authenticateRepository.authenticateWithAkamai(
            _accessToken, _idToken, _refreshToken);
      }
    } catch (e) {
      rethrow;
    } finally {
      runInAction(() => this.isBusyWithAkamai = false);
    }
  }

  @action
  Future registerDevice({String deviceId, int applicationBadge = null}) {
    return authenticateRepository.registerDevice(
      deviceId: deviceId,
      applicationBadge: applicationBadge,
    );
  }
}
