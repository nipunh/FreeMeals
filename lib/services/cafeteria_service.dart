import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/services/notification_service.dart';
// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/models/order_model.dart';
// import 'package:platos_client_app/models/slot_times_model.dart';
// import 'package:platos_client_app/providers/cafeteria_provider.dart';
// import 'package:platos_client_app/providers/cart_provider.dart';
// import 'package:platos_client_app/screens/vendor_list_screen.dart';
// import 'package:platos_client_app/services/cart_service.dart';
// import 'package:platos_client_app/services/database_helper.dart';
// import 'package:platos_client_app/services/notification_service.dart';
// import 'package:platos_client_app/services/user_service.dart';
import 'package:provider/provider.dart';

class CafeteriasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  final CollectionReference _cafeteria = FirebaseFirestore.instance.collection('cafeterias');
  
  final CollectionReference _orders = FirebaseFirestore.instance.collection('orders');

  Future<Cafeteria> getCafeteriaByID(String cafeteriaId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> cafeDoc =
          await _cafeteria.doc(cafeteriaId).get();
      if (cafeDoc != null && cafeDoc.exists) {
        return Cafeteria.fromDocToCafeteria(cafeDoc);
      } else
        return null;
    } catch (err) {
      print('error cafe service- get cafe by selected cafe Id = ' +
          err.toString());
      throw (err);
    }
  }

  Future<void> selectCafe(String userId, Cafeteria cafe, Cafeteria oldCafe,
      BuildContext context) async {
        print('Selcted Cafe :'+ cafe.id);
    // try {
    //   if ((oldCafe == null) || (cafe.id != oldCafe.id)) {
    //     await DatabaseHelper().clearLocalCart();
    //     Provider.of<CartProvider>(context, listen: false).clearProviderCart();
    //     await CartService().clearCart(userId);
    //     await UserService().addCafeToUser(userId, cafe.id, cafe.companyId);
    //     if (oldCafe != null) {
    //       await NotificationService().selectCafeUnSubcribe(
    //           oldCafe.id, oldCafe.companyId, oldCafe.city);
    //     }

    //     await NotificationService()
    //         .selectCafeSubcribe(cafe.id, cafe.companyId, cafe.city);
    //     Provider.of<SelectedCafeteria>(context, listen: false)
    //         .setCafeteria(cafe.id, cafe.name, cafe.city, cafe.companyId);
    //   }
    //   return Navigator.of(context)
    //       .pushReplacementNamed(VendorListScreen.routeName);
    // } catch (err) {
    //   print('error Cafe selection screen - pvt fucntion select cafe = ' +
    //       err.toString());
    //   throw (err);
    // }
  }

  Future<Cafeteria> getCafeteriaByCode() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cafeDoc = await _cafeteria
          .where('cafeCode', isEqualTo: 1234.toInt())
          .limit(1)
          .get();
      if (cafeDoc == null || cafeDoc.docs.isEmpty)
        return null;
      else
        return Cafeteria.fromDocToCafeteria(cafeDoc.docs.first);
    } catch (err) {
      print('error cafe service- get cafe by selected cafe Code = ' +
          err.toString());
      throw (err);
    }
  }
}
//   Future<List<SlotTime>> getCafeSlotTimes(String cafeId) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> doc = await _cafeteria
//           .doc(cafeId)
//           .collection('staticValues')
//           .doc('currentSlotTimes')
//           .get();

//       return _snapshotSlots(doc);
//     } catch (err) {
//       print('error cafe service- get cafe slot times = ' + err.toString());
//       throw (err);
//     }
//   }

//   List<SlotTime> _snapshotSlots(DocumentSnapshot<Map<String, dynamic>> doc) {
//     return SlotTimes.fromDocToSlotTimes(doc).slots ?? [];
//   }

//   Future<void> addSlotBooking(String cafeId, String slot) async {
//     try {
//       await _cafeteria
//           .doc(cafeId)
//           .collection('staticValues')
//           .doc('currentSlotTimes')
//           .update({slot: FieldValue.increment(-1)});
//     } catch (err) {
//       print('error cafe service- add slot booking = ' + err.toString());
//       throw (err);
//     }
//   }

//   Future<void> editSlotBooking({
//     @required String cafeId,
//     @required String oldSlot,
//     @required String newSlot,
//     @required bool add,
//     @required bool delete,
//     @required Order order,
//   }) async {
//     try {
//       var batch = _db.batch();
//       if (add) {
//         batch.update(
//             _cafeteria
//                 .doc(cafeId)
//                 .collection('staticValues')
//                 .doc('currentSlotTimes'),
//             {newSlot: FieldValue.increment(-1)});
//         batch.update(_orders.doc(order.orderId), {'slotTime': newSlot});
//       } else {
//         if (delete) {
//           batch.update(
//               _cafeteria
//                   .doc(cafeId)
//                   .collection('staticValues')
//                   .doc('currentSlotTimes'),
//               {oldSlot: FieldValue.increment(1)});
//           batch.update(_orders.doc(order.orderId), {'slotTime': ''});
//         } else {
//           batch.update(
//               _cafeteria
//                   .doc(cafeId)
//                   .collection('staticValues')
//                   .doc('currentSlotTimes'),
//               {
//                 oldSlot: FieldValue.increment(1),
//                 newSlot: FieldValue.increment(-1),
//               });
//           batch.update(_orders.doc(order.orderId), {'slotTime': newSlot});
//         }
//       }
//       await batch.commit();
//     } catch (err) {
//       print('error cafe service- edit slot booking = ' + err.toString());
//       throw (err);
//     }
//   }
// }
