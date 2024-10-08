class Credential {
  static String leptonAPIKey = const String.fromEnvironment('lepton-apikey',
      defaultValue: 'LEPTON_API_KEY');
}
