import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_API_KEY')
  static const String supabaseApiKey = _Env.supabaseApiKey;
  
  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY')
  static const String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;
  
  @EnviedField(varName: 'FIREBASE_IOS_API_KEY')
  static const String firebaseIosApiKey = _Env.firebaseIosApiKey;
  
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static const String googleMapsApiKey = _Env.googleMapsApiKey;
}
