import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/models/user_model.dart';
// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/models/company_model.dart';
// import 'package:platos_client_app/models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _user = FirebaseFirestore.instance.collection('users');

  // final CollectionReference _companies =
  //     FirebaseFirestore.instance.collection('companies');

  // final CollectionReference _orders =
  //     FirebaseFirestore.instance.collection('orders');

  Stream<UserData> getUserData(String userId) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _user.doc(userId).snapshots();

    return stream.map(_snapshotCredits);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByID(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _user.doc(userId).get();

      if (userDoc.exists) {
        return userDoc;
      } else {
        print("returning null");
        return null;
      }
    } catch (err) {
      print('error user service- get user by selected user Id = ' +
          err.toString());
      throw (err);
    }
  }

  Stream<List<UserData>> getWaiters(String cafeId) {
    print("in service");
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = _user
        .where("cafeId", isEqualTo: cafeId)
        // .where("status", isEqualTo: 0)
        .orderBy('status')
        .snapshots();

    return stream.map(_snapshotCreditsWaiter);
  }

  List<UserData> _snapshotCreditsWaiter(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    final List<UserData> cartItems = snapshot.docs.map((doc) {
      return UserDoc.fromDoctoUserInfo(doc);
    }).toList();

    return cartItems;
  }


  Stream<List<dynamic>> getOfferBanners(String cafeId) {
    try {
     Stream<DocumentSnapshot<Map<String, dynamic>>> stream =  _db.collection("cafeterias").doc(cafeId).snapshots();
      
      return  stream.map(_snapshotBanner);
      
    } catch (err) {
      print('error waiter provider - get Waiters = ' +
          err.toString());
      throw (err);
    }
  }

  List<dynamic> _snapshotBanner(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.data()["offerBanners"];
  }

  UserData _snapshotCredits(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserDoc.fromDoctoUserInfo(snapshot);
  }

  bool isLeapYear(int value) =>
      value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);
  int daysInMonth(int year, int month) {
    const _daysInMonth = const [
      0,
      31,
      28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    var result = _daysInMonth[month];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  Future<String> selectWaiter(String waiterId, int status, User user) async {
    try {
      DateTime dateStart = DateTime.now().subtract(Duration(minutes: 30));
      Timestamp timeStart = Timestamp.fromDate(dateStart);

      QuerySnapshot<Map<String, dynamic>> userDoc = await _user
          .doc(waiterId)
          .collection("orders")
          .where("userId", isEqualTo: user.uid)
          .where("cafeId", isEqualTo: "CXdKnqsdwetprt885KVx")
          .where("waiterRequestTime", isGreaterThanOrEqualTo: timeStart)
          .where("waiterRequestTime", isLessThanOrEqualTo: Timestamp.now())
          .get();

      if (userDoc.size > 0) {
        print("OrderRequest Already exist");
        return userDoc.docs.first.id;
      } else {
        await _user.doc(waiterId).update({"status": status});

        DocumentReference<Map<String, dynamic>> orderReqDoc =
            _user.doc(waiterId).collection("orders").doc();

        orderReqDoc.set({
          'cafeId': "CXdKnqsdwetprt885KVx",
          'displayName':
              user.displayName == null ? "Anonymous" : user.displayName,
          'userId': user.uid == null ? "" : user.uid,
          'orderStatus': 0,
          'waiterRequestTime': DateTime.now(),
          'waiterAcceptedTime': null,
          'numberOfCustomers': 0,
          'tableNumber': 0,
          'userList': [],
        });

        return orderReqDoc.id;
      }
    } catch (err) {
      print('error while selecting waiter = ' + err.toString());
      return null;
    }
  }

  Future<bool> deleteOrderRequest(String waiterId, String orderId) async {
    try {
      print(waiterId);
      _user
          .doc(waiterId)
          .collection("orders")
          .doc(orderId)
          .delete()
          .then((value) => print("Document Deleted"),
              onError: (e) => print("Error updating document $e"));
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  void acceptUserRequest(String waiterId, String orderId, int tableNumber, int noOfCustomers) {
    try {
       _user.doc(waiterId).collection("orders").doc(orderId).update({
        "OrderStatus": 1,
        "waiterAcceptedTime": DateTime.now(),
        "tableNumber": tableNumber,
        "numberOfCustomers" : noOfCustomers
      });
    } catch (err) {
      print('error while acceptUserRequest = ' + err.toString());
      throw (err);
    }
  }

//   Future<bool> subsidyEmployeeIdCheck(String userId, Cafeteria cafe) async {
//     try {
//       bool empIdExists = false;
//       UserDoc userData;
//       DocumentSnapshot<Map<String, dynamic>> userDoc =
//           await _user.doc(userId).get();

//       // user data check not related to subsidy or emp Id
//       if (userDoc.exists) {
//         userData = _snapshotCredits(userDoc);

//         User user = FirebaseAuth.instance.currentUser;
//         if (user.displayName != user.displayName ||
//             user.email != userData.emailAddress ||
//             user.phoneNumber != userData.phone) {
//           await _user.doc(userId).update({
//             'displayName': user.displayName,
//             'emailAddress': user.email,
//             'phone': user.phoneNumber,
//           });
//         }
//       } else
//         return false;

//       // EMp Id
//       if (cafe.companyCafe) {
//         if (userData.empId != null && userData.empId.isNotEmpty)
//           empIdExists = true;
//       } else {
//         empIdExists = true;
//       }

//       // Subsiy check
//       if (cafe.subsidy) {
//         if (userData.subsidy) {
//           return empIdExists;
//         } else {
//           DocumentSnapshot<Map<String, dynamic>> companyDoc =
//               await _companies.doc(cafe.companyId).get();

//           Company company = Company.fromDocToCompany(companyDoc);

//           SubsidyEmployee employee = company.subsidyEmployee.firstWhere(
//               (SubsidyEmployee empl) => empl.email == userData.emailAddress,
//               orElse: null);
//           if (employee != null) {
//             List<Map<String, dynamic>> employeeList =
//                 List<Map<String, dynamic>>.from(
//                     companyDoc.data()['subsidyEmployee']);

//             Map<String, dynamic> empl = employeeList.firstWhere(
//                 (element) => element['email'] == userData.emailAddress,
//                 orElse: null);

//             if (empl != null) {
//               var batch = _db.batch();

//               DateTime now = DateTime.now();

//               int totalDays = daysInMonth(now.year, now.month);

//               batch.update(_user.doc(userId), {
//                 'approvedCompanyId': company.id,
//                 'subsidy': true,
//                 'subsidyType': company.subsidyType,
//                 'subsidyAmount': employee.subsidyAmount,
//                 'monthlySubsidyAmount': employee.monthlySubsidyAmount,
//                 'companyCredits': employee.subsidyAmount,
//                 'monthlyCompanyCredits': ((totalDays - now.day) / (totalDays)) *
//                     employee.monthlySubsidyAmount,
//               });

//               // remove
//               batch.update(_companies.doc(company.id), {
//                 'subsidyEmployee': FieldValue.arrayRemove([
//                   {...empl}
//                 ])
//               });
//               // add
//               empl['approved'] = true;
//               batch.update(_companies.doc(company.id), {
//                 'subsidyEmployee': FieldValue.arrayUnion([
//                   {...empl}
//                 ])
//               });

//               await batch.commit();
//               return empIdExists;
//             } else
//               return empIdExists;
//           } else
//             return empIdExists;
//         }
//       } else
//         return empIdExists;
//     } catch (err) {
//       print('error User service - get user = ' + err.toString());
//       throw Exception(err);
//     }
//   }

//   Future<void> addEmployeeId(String emplyId, bool visitor) async {
//     try {
//       var batch = _db.batch();
//       String userId = FirebaseAuth.instance.currentUser.uid;
//       await _user.doc(userId).update({
//         'empId': (visitor) ? null : emplyId.toUpperCase(),
//       });

//       DateTime daysAgo = DateTime.now().subtract(Duration(days: 5));

//       QuerySnapshot<Map<String, dynamic>> orderQuery = await _orders
//           .where('userId', isEqualTo: userId)
//           .where('dateTime', isGreaterThan: Timestamp.fromDate(daysAgo))
//           .get();

//       orderQuery.docs.forEach((element) {
//         batch.update(_orders.doc(element.id), {
//           'empId': (visitor)
//               ? userId.substring(0, 4).toUpperCase()
//               : emplyId.toUpperCase(),
//         });
//       });

//       return await batch.commit();
//     } catch (err) {
//       print('error User service - add empId to user = ' + err.toString());
//       throw Exception(err);
//     }
//   }

//   Future<void> editEmployeeId(String emplyId, bool visitor) async {
//     try {
//       var batch = _db.batch();
//       String userId = FirebaseAuth.instance.currentUser.uid;
//       await _user.doc(userId).update({
//         'empId': (visitor) ? null : emplyId.toUpperCase(),
//       });

//       DateTime daysAgo = DateTime.now().subtract(Duration(days: 5));
//       QuerySnapshot<Map<String, dynamic>> orderQuery = await _orders
//           .where('userId', isEqualTo: userId)
//           .where('dateTime', isLessThan: Timestamp.fromDate(daysAgo))
//           .get();
//       orderQuery.docs.forEach((element) {
//         batch.update(_orders.doc(element.id), {
//           'empId': (visitor)
//               ? userId.substring(0, 4).toUpperCase()
//               : emplyId.toUpperCase(),
//         });
//       });
//       return await batch.commit();
//     } catch (err) {
//       print('error User service - edit empId to user = ' + err.toString());
//       throw Exception(err);
//     }
//   }

//   Future<void> addCafeToUser(
//       String userId, String cafeId, String companyId) async {
//     try {
//       await _user.doc(userId).update({
//         'cafeteriaId': cafeId,
//         'companyId': companyId,
//       });
//     } catch (err) {
//       print('error User service - add cafe to user = ' + err.toString());
//       throw Exception(err);
//     }
//   }
// }

}
