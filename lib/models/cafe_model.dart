import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Cafeteria {
  String id;
  String name;
  String city;
  String country;
  bool isOpen;
  bool disabled;
  bool slotTimes;
  int cafeCode;
  bool feedback;
  bool orderNumber;
  bool flatFee;
  bool forceRating;
  List<String> banners;
  int loyaltyStamps;
  Map<String, dynamic> bannerSize;
  bool cafeLoyalty;
  int companyCode;
  int cafeLoyaltyStamps;
  bool autoAcceptTableRequest;


  Cafeteria({
    @required this.id,
    @required this.name,
    @required this.city,
    @required this.country,
    @required this.isOpen,
    @required this.disabled,
    @required this.slotTimes,
    @required this.cafeCode,
    @required this.feedback,
    @required this.orderNumber,
    @required this.flatFee,
    @required this.forceRating,
    @required this.banners,
    @required this.loyaltyStamps,
    @required this.bannerSize,
    @required this.cafeLoyalty,
    @required this.companyCode,
    @required this.cafeLoyaltyStamps,
    @required this.autoAcceptTableRequest,
  });

  static Cafeteria fromDocToCafeteria(
    DocumentSnapshot<Map<String, dynamic>> doc) {
    
    final data = doc.data();

    return Cafeteria(
      id: doc.id,
      name: data['name'],
      city: data['city'],
      country: data['country'],
      isOpen: data['isOpen'],
      disabled: data['disabled'],
      cafeCode: (data['cafeCode'] == null) ? 0.toInt() : data['cafeCode'].toInt(),
      slotTimes: data['slotTimes'] ?? false,
      feedback: data['feedback'] ?? true,
      orderNumber: data['orderNumber'] ?? false,
      flatFee: data['flatFee'] ?? false,
      forceRating: data['forceRating'] ?? true,
      loyaltyStamps: (data['loyaltyStamps'] == null) ? 0.toInt(): data['loyaltyStamps'].toInt(),
      bannerSize: (data['bannerSize'] == null) ? {'height' : 1, 'width' : 1}
        : {'height' : data['bannerSize']["height"], 'width' : data['bannerSize']["width"] },
      cafeLoyalty: data['cafeLoyalty'] ?? false,
      banners:
          (data['banners'] == null) ? [] : List<String>.from(data['banners']),
          companyCode: data['companyCode'],
      cafeLoyaltyStamps: (data['cafeLoyaltyStamps'] == null) ? 0.toInt() : data['cafeLoyaltyStamps'].toInt(),
      autoAcceptTableRequest: data['autoAcceptTableRequest'] ?? false,
    );
  }
}

abstract class CafesData {}

class Cafeterias implements CafesData {
  final List<Cafeteria> cafes;

  Cafeterias(this.cafes);
}

class Error implements CafesData {
  final String errorMsg;

  Error(this.errorMsg);
}

class Loading implements CafesData {
  const Loading();
}

















// import 'package:cloud_firestore/cloud_firestore.dart';

// class Cafeteria {
//   // String id;
//   String name;
//   // String city;
//   // String country;
//   // bool isOpen;
//   // bool disabled;
//   // bool slotTimes;
//   // int cafeCode;
//   // bool feedback;
//   // bool orderNumber;
//   // bool flatFee;
//   // bool forceRating;
//   // List<String> banners;
//   // int loyaltyStamps;
//   String link;
//   double bannerSize;
//     bool cafeLoyalty;
//   double loyaltyStamps;


//   Cafeteria(
//     // required this.id,
//    this.name,
//     // required this.city,
//     // required this.slotTimes,
//     // required this.isOpen,
//     // required this.disabled,
//     // required this.cafeCode,
//     // required this.feedback,
//     // required this.orderNumber,
//     // required this.flatFee,
//     // required this.forceRating,
//     // required this.banners,
//     // required this.country,
//     this.link,
//     this.bannerSize,
//     this.cafeLoyalty,  
//     this.loyaltyStamps,
//   );
  

//     static List<Cafeteria> generateCafes(){
//       return [
//         Cafeteria("Test Cafe1", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe2", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 2, false, 4),
//         Cafeteria("Test Cafe3", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 2, true, 4),
//         Cafeteria("Test Cafe4", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe5", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 4, true, 4),
//         Cafeteria("Test Cafe6", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe7", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe8", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 2, true, 4),
//         Cafeteria("Test Cafe9", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe10", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe11", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
//         Cafeteria("Test Cafe12", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 2, true, 4),
//         Cafeteria("Test Cafe13", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 4, true, 4),
//         Cafeteria("Test Cafe14", "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", 1, true, 4),
      
//       ];
//     }


//   // static Cafeteria fromDocToCafeteria(DocumentSnapshot<Map<String, dynamic>> doc) {
//   //   final data = doc.data();
//   //   return Cafeteria(
//   //     id: doc.id,
//   //     name: data?['name'],
//   //     city: data?['city'],
//   //     isOpen: data?['isOpen'],
//   //     disabled: data?['disabled'],
//   //     cafeCode:
//   //         (data?['cafeCode'] == null) ? 0.toInt() : data?['cafeCode'].toInt(),
//   //     slotTimes: data?['slotTimes'] ?? false,
//   //     feedback: data?['feedback'] ?? true,
//   //     forceRating: data?['forceRating'] ?? true,
//   //     orderNumber: data?['orderNumber'] ?? false,
//   //     flatFee: data?['flatFee'] ?? false,
//   //     country: data?['country'],
//   //     loyaltyStamps: data?['loyaltyStamps'],
//   //     link: data?['link'],
//   //     banners:
//   //         (data?['banners'] == null) ? [] : List<String>.from(data?['banners']),
//   //   );
//   // }
// }

// abstract class CafesData {}

// class Cafeterias implements CafesData {
//   final List<Cafeteria> cafes;

//   Cafeterias(this.cafes);
// }

// class Error implements CafesData {
//   final String errorMsg;

//   Error(this.errorMsg);
// }

// class Loading implements CafesData {
//   const Loading();
// }
