import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

class VersionService {
  final CollectionReference _staticValues =
      FirebaseFirestore.instance.collection('staticValues');

  Future<bool> versionStable() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int minVersion = 0;

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _staticValues.doc('minimumVersion').get();

      if (documentSnapshot != null && documentSnapshot.exists)
        minVersion = documentSnapshot.data()['consumerVersion'] ?? 0;

      int version = int.parse(packageInfo.buildNumber);

      return version >= minVersion;
    } catch (err) {
      print('Error Version Service - Version check' + err.toString());
      throw (err);
    }
  }
}
