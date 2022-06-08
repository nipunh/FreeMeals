import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final _auth = FirebaseAuth.instance;
  final _user = FirebaseFirestore.instance.collection('users');
  final _orderRef = FirebaseFirestore.instance.collection('orders');

  // get all cart items for cart screen
  Stream<OrderData> getCartItems(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = _user
        .doc(userId)
        .collection("orders")
        .where('status', isEqualTo: 0)
        .snapshots();

    return stream.map(_snapshotCarts);
  }

  Stream<OrderDoc> getOngoingOrder(String orderDocId) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _orderRef.doc(orderDocId).snapshots();

    return stream.map(_snapshotOrders);
  }

  OrderDoc _snapshotOrders(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return OrderDoc.fromDoctoOrderInfo(snapshot);
  }

  OrderRequests _snapshotCarts(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final List<OrderDoc> orderDoc = snapshot.docs.map((doc) {
      return OrderDoc.fromDoctoOrderInfo(doc);
    }).toList();

    print(orderDoc);
    return OrderRequests(orderDoc);
  }
}
