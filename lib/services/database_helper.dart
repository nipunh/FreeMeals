// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:platos_client_app/models/cart_model.dart';
// import 'package:platos_client_app/models/order_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// // Database table
// // orderItems
// final String tableOrderItems = 'orderItems';
// final String columnItemOrderId = 'orderId';
// final String columnItemId = 'itemId';
// final String columnItemName = 'itemName';
// final String columnPrice = 'price';
// final String columnQuantity = 'qunatity';

// // orders
// final String tableOrders = 'orders';
// final String columnOrderId = 'orderId';
// final String columnUserId = 'userId';
// final String columnAmount = 'amount';
// final String columnDateTime = 'dataTime';
// final String columnOrderStatus = 'orderStatus';
// final String columnCafeName = 'cafeName';
// final String columnOtp = 'otp';
// final String columnVendorId = 'vendorId';
// final String columnCafeId = 'cafeId';
// final String columnVendorName = 'vendorName';
// final String columnOrderNumber = 'orderNumber';

// // cart
// final String tableCart = 'cart';
// final String columnCartCafeId = 'cafeId';
// final String columnCartVendorId = 'vendorId';
// final String columnCartItemId = 'itemId';
// final String columnCartQuantity = 'quantity';
// final String columnCartPrice = 'price';
// final String columnCartRequest = 'request';
// final String columnCartPreOrder = 'preOrder';
// final String columnCartOrderDateTime = 'orderDateTime';
// final String columnCartOrderExpireDateTime = 'orderExpireDateTime';

// class DatabaseHelper {
//   DatabaseHelper();
//   static final _databaseName = 'database.db';

//   static final _databaseVersion = 19;

//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database _database;
//   FutureOr<Database> get database async {
//     try {
//       if (_database != null) {
//         int currentDatabaseVersion = await _database.getVersion();
//         if (currentDatabaseVersion == _databaseVersion) {
//           return _database;
//         } else {
//           _database = await _initDatabase();
//           return _database;
//         }
//       } else {
//         _database = await _initDatabase();
//         return _database;
//       }
//     } catch (err) {
//       print('error localdb - private fuction database get = ' + err.toString());
//       throw (err);
//     }
//   }

//   _initDatabase() async {
//     try {
//       Directory documentDirectory = await getApplicationDocumentsDirectory();
//       String path = join(documentDirectory.path, _databaseName);
//       return await openDatabase(path,
//           version: _databaseVersion,
//           onCreate: _onCreate,
//           onUpgrade: _onUpgrade);
//     } catch (err) {
//       print('error localdb - private fuction initDatabase = ' + err.toString());
//       throw (err);
//     }
//   }

//   FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     try {
//       await db.execute('''DROP TABLE IF EXISTS $tableOrderItems''');
//       await db.execute('''DROP TABLE IF EXISTS $tableOrders''');
//       await db.execute('''DROP TABLE IF EXISTS $tableCart''');
//       _onCreate(db, newVersion);
//     } catch (err) {
//       print('error localdb - private fuction onUpgrade = ' + err.toString());
//       throw (err);
//     }
//   }

//   FutureOr<void> _onCreate(Database db, int version) async {
//     try {
//       await db.execute('''CREATE TABLE 
//     $tableOrders (
//       $columnOrderId TEXT PRIMARY KEY,
//       $columnUserId TEXT NOT NULL,
//       $columnAmount REAL NOT NULL,
//       $columnDateTime TEXT NOT NULL,
//       $columnCafeName TEXT NOT NULL,
//       $columnOrderStatus INT NOT NULL,
//       $columnOtp TEXT NOT NULL,
//       $columnVendorId TEXT NOT NULL,
//       $columnCafeId TEXT NOT NULL,
//       $columnVendorName TEXT NOT NULL,
//       $columnOrderNumber TEXT NOT NULL
//     )''');

//       await db.execute('''CREATE TABLE 
//     $tableOrderItems (
//       $columnItemOrderId TEXT NOT NULL,
//       $columnItemId TEXT NOT NULL,
//       $columnItemName TEXT NOT NULL,
//       $columnPrice REAL NOT NULL,
//       $columnQuantity INT NOT NULL
//     )''');

//       await db.execute('''CREATE TABLE 
//     $tableCart (
//       $columnCartCafeId  TEXT NOT NULL,
//       $columnCartVendorId  TEXT NOT NULL,
//       $columnCartItemId TEXT NOT NULL,
//       $columnCartQuantity INT NOT NULL,
//       $columnCartPrice REAL NOT NULL,
//       $columnCartRequest TEXT NOT NULL,
//       $columnCartPreOrder TEXT NOT NULL,
//       $columnCartOrderDateTime TEXT,
//       $columnCartOrderExpireDateTime INT
//     )''');
//     } catch (err) {
//       print('error localdb - private fuction onCreate = ' + err.toString());
//       throw (err);
//     }
//   }

//   // add/upadte private method for code reduction
//   Future<void> _addCartItem(List<Map<String, dynamic>> dbCart, Database db,
//       LocalCartItem cartItem) async {
//     try {
//       final vendorCartItem = dbCart
//           .where((item) => item[columnCartVendorId] == cartItem.vendorId)
//           .toList();

//       if (vendorCartItem.isEmpty) {
//         await db.insert(tableCart, {
//           columnCartCafeId: cartItem.cafeId,
//           columnCartVendorId: cartItem.vendorId,
//           columnCartItemId: cartItem.itemId,
//           columnCartPrice: cartItem.price,
//           columnCartQuantity: cartItem.quantity,
//           columnCartPreOrder: cartItem.preOrder.toString(),
//           columnCartOrderDateTime: (cartItem.orderDateTime != null)
//               ? cartItem.orderDateTime.toIso8601String()
//               : 'null',
//           columnCartOrderExpireDateTime: cartItem.orderExpireDateTime ?? null,
//           columnCartRequest: '',
//         });
//       } else {
//         String request = vendorCartItem.first['request'];
//         await db.insert(tableCart, {
//           columnCartCafeId: cartItem.cafeId,
//           columnCartVendorId: cartItem.vendorId,
//           columnCartItemId: cartItem.itemId,
//           columnCartPrice: cartItem.price,
//           columnCartQuantity: cartItem.quantity,
//           columnCartPreOrder: cartItem.preOrder.toString(),
//           columnCartOrderDateTime: (cartItem.orderDateTime != null)
//               ? cartItem.orderDateTime.toIso8601String()
//               : 'null',
//           columnCartOrderExpireDateTime: cartItem.orderExpireDateTime ?? null,
//           columnCartRequest: request ?? '',
//         });
//       }
//     } catch (err) {
//       print('error localdb - private add function in the helper = ' +
//           err.toString());
//       throw (err);
//     }
//   }

//   // fetch cart from local db to add to firestore db

//   Future<List<LocalCartItem>> getCartFromLocal() async {
//     try {
//       Database db = await database;
//       List<LocalCartItem> cart = [];
//       final dbCart = await db.query(tableCart);

//       if (dbCart.isEmpty) {
//         return cart;
//       } else {
//         cart = dbCart
//             .map((dbCart) => LocalCartItem(
//                 cafeId: dbCart[columnCartCafeId],
//                 vendorId: dbCart[columnCartVendorId],
//                 itemId: dbCart[columnCartItemId],
//                 price: dbCart[columnCartPrice],
//                 quantity: dbCart[columnCartQuantity],
//                 request: dbCart[columnCartRequest],
//                 orderDateTime: (dbCart[columnCartOrderDateTime] != null &&
//                         dbCart[columnCartOrderDateTime] != 'null')
//                     ? DateTime.parse((dbCart[columnCartOrderDateTime]))
//                     : null,
//                 orderExpireDateTime:
//                     (dbCart[columnCartOrderExpireDateTime] != null)
//                         ? dbCart[columnCartOrderExpireDateTime]
//                         : null,
//                 preOrder:
//                     (dbCart[columnCartPreOrder] != 'true') ? false : true))
//             .toList();

//         cart.forEach((LocalCartItem localCartItem) {
//           if (localCartItem.preOrder) {
//             DateTime currentDateTime = DateTime.now();
//             bool isBefore = currentDateTime.isBefore(
//                 (localCartItem.orderDateTime).subtract(
//                     Duration(hours: (localCartItem.orderExpireDateTime))));
//             if (!isBefore) {
//               cart.remove(localCartItem);
//               removeCartItem(localCartItem.vendorId, localCartItem.itemId,
//                   localCartItem.preOrder, localCartItem.orderDateTime);
//             }
//           }
//         });
//         return cart;
//       }
//     } catch (err) {
//       print('error localdb - get items from local cart = ' + err.toString());
//       throw (err);
//     }
//   }

//   //  add CartItem to local DB
//   Future<void> addCartItem(LocalCartItem cartItem) async {
//     try {
//       Database db = await database;

//       var dbCart = await db.query(tableCart);

//       String orderDateTime = (cartItem.orderDateTime == null)
//           ? 'null'
//           : cartItem.orderDateTime.toIso8601String();

//       List<Map<String, dynamic>> previousCartItem = [];

//       previousCartItem = dbCart
//           .where((item) =>
//               item[columnCartItemId] == cartItem.itemId &&
//               item[columnCartVendorId] == cartItem.vendorId &&
//               item[columnCartPreOrder] == cartItem.preOrder.toString() &&
//               item[columnCartOrderDateTime] == orderDateTime)
//           .toList();

//       if (previousCartItem.isEmpty) {
//         await _addCartItem(dbCart, db, cartItem);
//       }
//       if (previousCartItem.length == 1) {
//         await db.update(tableCart, {columnCartQuantity: cartItem.quantity},
//             where: '${[columnCartItemId]} = ? AND ${[
//               columnCartVendorId
//             ]} = ? AND ${[columnCartPreOrder]} = ? AND ${[
//               columnCartOrderDateTime
//             ]} = ? ',
//             whereArgs: [
//               cartItem.itemId,
//               cartItem.vendorId,
//               cartItem.preOrder.toString(),
//               orderDateTime
//             ]);
//       }
//       if (previousCartItem.length > 1) {
//         await db.delete(tableCart,
//             where: '${[columnCartItemId]} = ? AND ${[
//               columnCartVendorId
//             ]} = ? AND ${[columnCartPreOrder]} = ? AND ${[
//               columnCartOrderDateTime
//             ]} = ?',
//             whereArgs: [
//               cartItem.itemId,
//               cartItem.vendorId,
//               cartItem.preOrder.toString(),
//               orderDateTime
//             ]);
//         await _addCartItem(dbCart, db, cartItem);
//       }
//     } catch (err) {
//       print('error localdb - add item to cart= ' + err.toString());
//       throw (err);
//     }
//   }

// // update quantity to local db
//   Future<void> updateQuantity(LocalCartItem cartItem) async {
//     try {
//       Database db = await database;

//       var dbCart = await db.query(tableCart);
//       String orderDateTime = (cartItem.orderDateTime == null)
//           ? 'null'
//           : cartItem.orderDateTime.toIso8601String();

//       List<Map<String, dynamic>> previousCartItem = [];

//       previousCartItem = dbCart
//           .where((item) =>
//               item[columnCartItemId] == cartItem.itemId &&
//               item[columnCartVendorId] == cartItem.vendorId &&
//               item[columnCartPreOrder] == cartItem.preOrder.toString() &&
//               item[columnCartOrderDateTime] == orderDateTime)
//           .toList();

//       if (previousCartItem.isEmpty) {
//         await _addCartItem(dbCart, db, cartItem);
//       }
//       if (previousCartItem.length == 1) {
//         await db.update(tableCart, {columnCartQuantity: cartItem.quantity},
//             where: '${[columnCartItemId]} = ? AND ${[
//               columnCartVendorId
//             ]} = ? AND ${[columnCartPreOrder]} = ? AND ${[
//               columnCartOrderDateTime
//             ]} = ?',
//             whereArgs: [
//               cartItem.itemId,
//               cartItem.vendorId,
//               cartItem.preOrder.toString(),
//               orderDateTime
//             ]);
//       }
//       if (previousCartItem.length > 1) {
//         await db.delete(tableCart,
//             where: '${[columnCartItemId]} = ? AND ${[
//               columnCartVendorId
//             ]} = ? AND ${[columnCartPreOrder]} = ? AND ${[
//               columnCartOrderDateTime
//             ]} = ?',
//             whereArgs: [
//               cartItem.itemId,
//               cartItem.vendorId,
//               cartItem.preOrder.toString(),
//               orderDateTime
//             ]);
//         await _addCartItem(dbCart, db, cartItem);
//       }
//     } catch (err) {
//       print('error localdb - upadte qty of cart item = ' + err.toString());
//       throw (err);
//     }
//   }

// // remove cartItem from local db
//   Future<void> removeCartItem(String vendorId, String itemId, bool preOrder,
//       DateTime orderDateTime) async {
//     try {
//       Database db = await database;
//       String orderTime =
//           (orderDateTime == null) ? 'null' : orderDateTime.toIso8601String();

//       await db.delete(tableCart,
//           where:
//               '${[columnCartItemId]} = ? AND ${[columnCartVendorId]} = ? AND ${[
//             columnCartPreOrder
//           ]} = ? AND ${[columnCartOrderDateTime]} = ?',
//           whereArgs: [itemId, vendorId, preOrder.toString(), orderTime]);
//     } catch (err) {
//       print('error localdb - = remove item from cart ' + err.toString());
//       throw (err);
//     }
//   }

//   // add request in cart screen
//   Future<void> addRequestVendorCart(String vendorId, String request) async {
//     try {
//       Database db = await database;
//       await db.update(tableCart, {columnCartRequest: request},
//           where: '${[columnCartVendorId]} = ? AND ${[columnCartPreOrder]} = ?',
//           whereArgs: [vendorId, false.toString()]);
//     } catch (err) {
//       print('error localdb - = add request to vendor cart' + err.toString());
//       throw (err);
//     }
//   }

// // remove vendor from cart screen
//   Future<void> removeVendorFromCart(String vendorId, bool preOrder) async {
//     try {
//       Database db = await database;

//       await db.delete(tableCart,
//           where: '${[columnCartVendorId]} = ? AND ${[columnCartPreOrder]} = ?',
//           whereArgs: [vendorId, preOrder.toString()]);
//     } catch (err) {
//       print('errro localdb - remove vendor from cart = ' + err.toString());
//       throw (err);
//     }
//   }

//   // Clear cart in local db
//   Future<void> clearLocalCart() async {
//     try {
//       Database db = await database;

//       await db.delete(tableCart);
//     } catch (err) {
//       print('errror localdb - clear cart = ' + err.toString());
//       throw (err);
//     }
//   }

//   // add pervoius order to cart
//   Future<void> reOrderToCart(Order order) async {
//     try {
//       Database db = await database;

//       var dbCart = await db.query(tableCart);
//       List<LocalCartItem> cart = dbCart
//           .map((dbCart) => LocalCartItem(
//               cafeId: dbCart[columnCartCafeId],
//               vendorId: dbCart[columnCartVendorId],
//               itemId: dbCart[columnCartItemId],
//               price: dbCart[columnCartPrice],
//               quantity: dbCart[columnCartQuantity],
//               request: dbCart[columnCartRequest],
//               orderDateTime: (dbCart[columnCartOrderDateTime] != null &&
//                       dbCart[columnCartOrderDateTime] != 'null')
//                   ? DateTime.parse((dbCart[columnCartOrderDateTime]))
//                   : null,
//               orderExpireDateTime:
//                   (dbCart[columnCartOrderExpireDateTime] != null)
//                       ? dbCart[columnCartOrderExpireDateTime]
//                       : null,
//               preOrder: (dbCart[columnCartPreOrder] != 'true') ? false : true))
//           .toList();

//       await Future.forEach(order.items, (OrderItem orderItem) async {
//         bool itemInCart = cart.any((item) =>
//             item.itemId == orderItem.itemId &&
//             item.vendorId == order.vendorId &&
//             item.preOrder == false &&
//             item.orderDateTime == null);
//         if (itemInCart) {
//           final item = cart.firstWhere((item) =>
//               item.itemId == orderItem.itemId &&
//               item.vendorId == order.vendorId &&
//               item.preOrder == false &&
//               item.orderDateTime == null);
//           int quantity = item.quantity + orderItem.quantity;
//           await db.update(tableCart, {columnCartQuantity: quantity},
//               where: '${[columnCartItemId]} = ? AND ${[
//                 columnCartVendorId
//               ]} = ? AND ${[columnCartPreOrder]} = ? AND ${[
//                 columnCartOrderDateTime
//               ]} = ?',
//               whereArgs: [
//                 orderItem.itemId,
//                 order.vendorId,
//                 false.toString(),
//                 null
//               ]);
//         } else {
//           LocalCartItem cartItem = LocalCartItem(
//               cafeId: order.cafeId,
//               itemId: orderItem.itemId,
//               price: orderItem.price,
//               quantity: orderItem.quantity,
//               vendorId: order.vendorId,
//               preOrder: false,
//               orderDateTime: null,
//               orderExpireDateTime: null);
//           _addCartItem(dbCart, db, cartItem);
//         }
//       });
//     } catch (err) {
//       print('error reorder to cart - local db = ' + err.toString());
//       throw (err);
//     }
//   }

//   // Add orders to phone data after every place order(pressed cart screen)
//   Future<void> addOrder(List<Order> orders) async {
//     try {
//       Database db = await database;

//       await db.delete(tableOrders);
//       await db.delete(tableOrderItems);

//       await Future.forEach(orders, (Order order) async {
//         await db.insert(tableOrders, {
//           columnOrderId: order.orderId,
//           columnUserId: order.userId,
//           columnAmount: order.amount,
//           columnDateTime: order.dateTime.toIso8601String(),
//           columnOrderStatus: order.orderStatus,
//           columnCafeName: order.cafeName,
//           columnOtp: order.otp,
//           columnVendorId: order.vendorId,
//           columnCafeId: order.cafeId,
//           columnVendorName: order.vendorName,
//           columnOrderNumber: order.orderNumber,
//         });

//         await Future.forEach(order.items, (OrderItem orderItem) async {
//           await db.insert(tableOrderItems, {
//             columnItemOrderId: order.orderId,
//             columnItemId: orderItem.itemId,
//             columnItemName: orderItem.itemName,
//             columnPrice: orderItem.price,
//             columnQuantity: orderItem.quantity,
//           });
//         });
//       });
//     } catch (err) {
//       print('error local db - create table/ add order = ' + err.toString());
//       throw Exception(err);
//     }
//   }

//   // offline order screen pressing error page button
//   Future<List<OfflineOrder>> getOfflineOrders() async {
//     try {
//       Database db = await database;

//       var dbOrders = await db.query(tableOrders);
//       var dbOrderItems = await db.query(tableOrderItems);

//       return dbOrders.map((dbOrder) {
//         var dbOrderItemsForId = dbOrderItems
//             .where((dbOrderItem) =>
//                 dbOrderItem[columnItemOrderId] == dbOrder[columnOrderId])
//             .toList();
//         return OfflineOrder(
//             orderId: dbOrder[columnOrderId],
//             amount: dbOrder[columnAmount],
//             cafeId: dbOrder[columnCafeId],
//             cafeName: dbOrder[columnCafeName],
//             dateTime: DateTime.parse(dbOrder[columnDateTime]),
//             orderNumber: dbOrder[columnOrderNumber],
//             orderStatus: dbOrder[columnOrderStatus],
//             otp: dbOrder[columnOtp],
//             userId: dbOrder[columnUserId],
//             vendorId: dbOrder[columnVendorId],
//             vendorName: dbOrder[columnVendorName],
//             items: List<OfflineOrderItem>.from(
//               dbOrderItemsForId.map((dbOrderItem) {
//                 return OfflineOrderItem(
//                     itemId: dbOrderItem[columnItemId],
//                     itemName: dbOrderItem[columnItemName],
//                     price: dbOrderItem[columnPrice],
//                     quantity: dbOrderItem[columnQuantity]);
//               }).toList(),
//             ));
//       }).toList();
//     } catch (err) {
//       print('error local db - fetch order = ' + err.toString());
//       throw Exception(err);
//     }
//   }
// }
