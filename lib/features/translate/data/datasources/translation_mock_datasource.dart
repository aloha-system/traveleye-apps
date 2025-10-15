class TranslationMockDatasource {
  const TranslationMockDatasource();

  Future<String> translateText(String text, String from, String to) async {
    await Future.delayed(const Duration(seconds: 1));

    if (from == 'en' && to == 'id') {
      return _translateEnToId(text);
    } else if (from == 'id' && to == 'en') {
      return _translateIdToEn(text);
    }
    
    return text;
  }

  String _translateEnToId(String text) {
    final translations = {
      'hello': 'halo',
      'thank you': 'terima kasih',
      'good morning': 'selamat pagi',
      'good afternoon': 'selamat siang',
      'good evening': 'selamat sore',
      'good night': 'selamat malam',
      'how are you': 'apa kabar',
      'where is': 'di mana',
      'how much': 'berapa harga',
      'i need help': 'saya butuh bantuan',
      'excuse me': 'permisi',
      'sorry': 'maaf',
      'yes': 'ya',
      'no': 'tidak',
      'please': 'tolong',
      'water': 'air',
      'food': 'makanan',
      'restaurant': 'restoran',
      'hotel': 'hotel',
      'hospital': 'rumah sakit',
      'police': 'polisi',
      'bathroom': 'kamar mandi',
      'money': 'uang',
      'expensive': 'mahal',
      'cheap': 'murah',
      'beautiful': 'cantik',
      'delicious': 'enak',
      'hot': 'panas',
      'cold': 'dingin',
      'big': 'besar',
      'small': 'kecil',
    };

    String result = text.toLowerCase();
    translations.forEach((english, indonesian) {
      result = result.replaceAll(english, indonesian);
    });

    return result.isNotEmpty ? result : 'Terjemahan tidak tersedia';
  }

  String _translateIdToEn(String text) {
    final translations = {
      'halo': 'hello',
      'terima kasih': 'thank you',
      'selamat pagi': 'good morning',
      'selamat siang': 'good afternoon',
      'selamat sore': 'good evening',
      'selamat malam': 'good night',
      'apa kabar': 'how are you',
      'di mana': 'where is',
      'berapa harga': 'how much',
      'saya butuh bantuan': 'i need help',
      'permisi': 'excuse me',
      'maaf': 'sorry',
      'ya': 'yes',
      'tidak': 'no',
      'tolong': 'please',
      'air': 'water',
      'makanan': 'food',
      'restoran': 'restaurant',
      'hotel': 'hotel',
      'rumah sakit': 'hospital',
      'polisi': 'police',
      'kamar mandi': 'bathroom',
      'uang': 'money',
      'mahal': 'expensive',
      'murah': 'cheap',
      'cantik': 'beautiful',
      'enak': 'delicious',
      'panas': 'hot',
      'dingin': 'cold',
      'besar': 'big',
      'kecil': 'small',
    };

    String result = text.toLowerCase();
    translations.forEach((indonesian, english) {
      result = result.replaceAll(indonesian, english);
    });

    return result.isNotEmpty ? result : 'Translation not available';
  }
}
