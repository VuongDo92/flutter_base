import 'package:core/repositories/authenticate_repository.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mobx/mobx.dart';

part 'akamai_store.g.dart';

class AkamaiStore = _AkamaiStore with _$AkamaiStore;

abstract class _AkamaiStore with Store {

  FlutterAppAuth _appAuth;

  final AuthenticateRepository authenticateRepository;

  String get akamaiClientId => authenticateRepository.akamaiClientId;
  String get akamaiAuthorizationEndpoint => authenticateRepository.akamaiAuthorizationEndpoint;
  String get akamaiTokenEndpoint => authenticateRepository.akamaiTokenEndpoint;
  String get akamaiRedirectURL => authenticateRepository.akamaiRedirectURL;
  String get akamaiSchemeURL => authenticateRepository.akamaiSchemeURL;
  get akamaiScopes => authenticateRepository.akamaiScopes;

  _AkamaiStore({this.authenticateRepository}) {
    _appAuth = FlutterAppAuth();
  }

  @observable
  bool isBusyAkamai = false;

  Future akamaiAuthorize() async {
    final AuthorizationServiceConfiguration _serviceConfiguration =
    AuthorizationServiceConfiguration(
        akamaiAuthorizationEndpoint,
        akamaiTokenEndpoint);
    final AuthorizationResponse result = await _appAuth.authorize(
      AuthorizationRequest(
          akamaiClientId,
          akamaiRedirectURL,
          scopes: akamaiScopes,
          serviceConfiguration: _serviceConfiguration,
          promptValues: ['login']),
    );
  }
}
