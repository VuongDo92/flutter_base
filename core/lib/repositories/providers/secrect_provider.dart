/// Interface for a class that store secret information
abstract class SecretProvider {
  Future<String> getSessionToken();
  Future saveSessionToken(String token);

  Future deleteSessionToken() => saveSessionToken(null);
}
