library streampay;

import 'dart:convert';

import 'package:flutter_bcrypt/flutter_bcrypt.dart';

class StreamPay {
  /// Crea TKA(Token de autenticación) a partir del TKR(Token de registro)
  /// y numero de afiliación
  static Future<String> createTKA(String tKR, String affiliation) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final timeDecimal =
        time.toRadixString(10).codeUnits; //"1616658194192".codeUnits;
    final tkrdecimal = tKR.codeUnits;
    final affiliationDecimal = affiliation.codeUnits;

    final cad1 = calculateOr(tkrdecimal, timeDecimal);
    final cad2 = calculateXOr(cad1.codeUnits, affiliationDecimal);
    var bytesInLatin1 = latin1.encode(cad2);
    var base64encoded = base64.encode(bytesInLatin1);
    var salt11 = await FlutterBcrypt.saltWithRounds(rounds: 11);
    var tka = await FlutterBcrypt.hashPw(password: base64encoded, salt: salt11);
    // final tka =
    //     DBCrypt().hashpw(base64encoded, DBCrypt().gensaltWithRounds(11));
    return tka;
  }

  /// Crea TKA(Token de autenticación) a partir del TKR(Token de registro)
  /// numero de afiliación y timestamp
  static Future<String> createTKATime(
      String tKR, String affiliation, String time) async {
    final timeDecimal = time.codeUnits;
    print("time decimal:  $timeDecimal");
    final tkrdecimal = tKR.codeUnits;
    print(tkrdecimal);
    final affiliationDecimal = affiliation.codeUnits;
    print(affiliationDecimal);

    final cad1 = calculateOr(tkrdecimal, timeDecimal);
    print("or : $cad1");
    final cad2 = calculateXOr(cad1.codeUnits, affiliationDecimal);
    print("xor: $cad2");
    var bytesInLatin1 = latin1.encode(cad2);
    print("bytesinlatin: $bytesInLatin1");
    var base64encoded = base64.encode(bytesInLatin1);
    print("base64: $base64encoded");
    var salt11 = await FlutterBcrypt.saltWithRounds(rounds: 11);
    print("salt11: $salt11");
    var tka = await FlutterBcrypt.hashPw(password: base64encoded, salt: salt11);
    print("tka: $tka");
    // final tka =
    //     DBCrypt().hashpw(base64encoded, DBCrypt().gensaltWithRounds(11));
    return tka;
  }

  /// Calcula la operación OR de un dos listados de enteros
  static String calculateOr(List<int> arg1, List<int> arg2) {
    var result = "";
    var cad1 = _copyArray(arg1);
    var cad2 = _copyArray(arg2);

    if (cad1.length == cad2.length) {
      result = _doOrOperation(cad1, cad2);
    } else if (cad1.length > cad2.length) {
      final cad2aux = _fillArray(cad2, cad1.length);
      result = _doOrOperation(cad1, cad2aux);
    } else if (cad2.length > cad1.length) {
      final cad1aux = _fillArray(cad1, cad2.length);
      result = _doOrOperation(cad1aux, cad2);
    }
    return result;
  }

  /// Calcula la operación XOR de un dos listados de enteros
  static String calculateXOr(List<int> arg1, List<int> arg2) {
    var result = "";
    var cad1 = _copyArray(arg1);
    var cad2 = _copyArray(arg2);

    if (cad1.length == cad2.length) {
      result = _doXOrOperation(cad1, cad2);
    } else if (cad1.length > cad2.length) {
      final cad2aux = _fillArray(cad2, cad1.length);
      result = _doXOrOperation(cad1, cad2aux);
    } else if (cad2.length > cad1.length) {
      final cad1aux = _fillArray(cad1, cad2.length);
      result = _doXOrOperation(cad1aux, cad2);
    }
    return result;
  }

  static String _doOrOperation(List<int> cad1, List<int> cad2) {
    final length = cad1.length;
    var result = '';
    for (var i = 0; i < length; i++) {
      final or = (cad1[i] | cad2[i]);
      final character = String.fromCharCode(or);
      result += character;
    }
    return result;
  }

  static String _doXOrOperation(List<int> cad1, List<int> cad2) {
    final length = cad1.length;
    var result = '';
    for (var i = 0; i < length; i++) {
      final or = (cad1[i] ^ cad2[i]);
      final character = String.fromCharCode(or);
      result += character;
    }
    return result;
  }

  static List<int> _fillArray(List<int> cad, int length) {
    final finalLength = length - cad.length;
    for (var i = 0; i < finalLength; i++) {
      cad.add(0);
    }
    return cad;
  }

  static List<int> _copyArray(List<int> list) {
    var newList = <int>[];
    for (var i = 0; i < list.length; i++) {
      newList.add(list[i]);
    }
    return newList;
  }
}
