import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class Encrypt {
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
