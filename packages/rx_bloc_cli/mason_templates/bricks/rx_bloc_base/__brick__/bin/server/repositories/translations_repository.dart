{{> licence.dart }}

import 'dart:convert';

class TranslationsRepository {
  Map<String, dynamic> getTranslations() => _demoTranslations;

  final Map<String, dynamic> _demoTranslations = jsonDecode('''
    {
       "en":{
          "_ok":"Okay",
          "login___logIn" : "Login"
       },
       "bg":{
          "_ok":"ok",
          "login___logIn" : "Вход"
       }
    }
    ''');
}
