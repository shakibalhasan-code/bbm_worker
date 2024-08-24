import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../core/models/worker.dart';

class ProfileController extends GetxController {
  var user = UserModel(
    fullName: '',
    email: '',
    imageUrl: '',
    phone: '',
    role: '',
  ).obs;


  Future<void> fetchUserData(String workerEmail) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(workerEmail)
        .get();

    if (doc.exists) {
      user.value = UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }
  }
}
