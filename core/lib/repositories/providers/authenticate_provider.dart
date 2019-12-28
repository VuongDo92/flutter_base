

abstract class AuthenticateProvider {
  /// Akamai configuration
  /// todo fetch remoteConfig
  ///
  String clientId = "5451ed44-d322-499a-a96b-c0665388ae60";
  String redirectURL = "ph.com.globe.globeone.prod://oauth2redirect/akamai-identity-cloud-provider";
  String authorizationEndpoint = "https://login.globe.com.ph/018b1c35-e0d9-39e1-967b-3f4cacd6d000/auth-ui/login";
  String tokenEndpoint = "https://login.globe.com.ph/018b1c35-e0d9-39e1-967b-3f4cacd6d000/login/token";
  String schemeURL = "";

  Future<void> init();
}