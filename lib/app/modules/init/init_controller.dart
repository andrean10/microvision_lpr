import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../data/shared_preferences/user_session.dart';

class InitController extends GetxController {
  // late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  // late final FirebaseStorage _storage;
  late final GetStorage _box;

  final logger = Logger();

  var isAppAlreadyConnectedFirstTime = true;

  // FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  // FirebaseStorage get storage => _storage;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    // _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    // _storage = FirebaseStorage.instance;
    _box = GetStorage();
  }

  Future<UserSession?> getSession() async {
    final id = _box.read('id') as String?;
    final userId = _box.read('userId') as String?;
    final password = _box.read('password') as String?;

    if (id != null && userId != null && password != null) {
      return UserSession(
        id: id,
        userID: userId,
        password: password,
      );
    }

    return null;
  }

  Future<void> setSession(UserSession session) async {
    await _box.write('id', session.id);
    await _box.write('userId', session.userID);
    await _box.write('password', session.password);
  }

  Future<void> deleteSession() async => await _box.erase();

  // bool isUserLogged() {
  //   final user = auth.currentUser;
  //   return user != null;
  // }
}
