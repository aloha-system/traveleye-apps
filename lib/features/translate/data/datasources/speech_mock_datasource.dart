class SpeechMockDatasource {
  const SpeechMockDatasource();

  Future<void> speakText(String text, String language) async {
    // Simulate text-to-speech delay
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String> speechToText(String language) async {
    await Future.delayed(const Duration(seconds: 3));

    if (language == 'en') {
      return 'Hello, how are you today?';
    } else if (language == 'id') {
      return 'Halo, apa kabar hari ini?';
    }
    
    return 'Speech recognition not available';
  }
}
