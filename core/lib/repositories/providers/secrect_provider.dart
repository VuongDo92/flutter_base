/// Interface for a class that store secret information
abstract class SecretProvider {
  Future<String> getToken();
  Future saveToken(String token);

  Future deleteToken() => saveToken(null);
}
