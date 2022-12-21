import 'package:shared_preferences/shared_preferences.dart';

T ler<T>(SharedPreferences prefs, String chave, T padrao){
  try{
    T? res = prefs.get(chave) as T;
    return res ?? padrao;
  }catch(e){
    return padrao;
  }
}

