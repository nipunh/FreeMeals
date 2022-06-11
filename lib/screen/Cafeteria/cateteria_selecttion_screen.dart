import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/config/stories_data.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/cafeteria_provider.dart';
import 'package:freemeals/screen/story_screen.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/device_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/util/bottom_items.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/qr_scanner.dart';
import 'package:freemeals/widgets/cafeteria_card.dart';
import 'package:freemeals/widgets/cafeteria_selection/cafeteria_details.dart';
import 'package:freemeals/widgets/dialog_boxes/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:platos_client_app/enums/connectivity_status.dart';
// import 'package:platos_client_app/enums/view_state.dart';
// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/models/company_model.dart';

// import 'package:platos_client_app/services/connectivity_service.dart';
// import 'package:platos_client_app/services/device_service.dart';

// import 'package:platos_client_app/widgets/app_wide/error_connection_page.dart';
// import 'package:platos_client_app/widgets/app_wide/error_page.dart';
// import 'package:platos_client_app/widgets/app_wide/loading_page.dart';
// import 'package:platos_client_app/widgets/app_wide/qr_scanner.dart';
// import 'package:platos_client_app/widgets/cafeteria_selection/cafeteria_details.dart';
// import 'package:platos_client_app/widgets/dialog_boxes/loading_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

class CafeteriaSelectionScreen extends StatefulWidget {
  static const routeName = '/cafe-selection';
  CafeteriaSelectionScreen({Key key}) : super(key: key);

  @override
  _CafeteriaSelectionScreenState createState() =>
      _CafeteriaSelectionScreenState();
}

class _CafeteriaSelectionScreenState extends State<CafeteriaSelectionScreen> {
  bool _isInit = true;
  bool _loading = true;
  int pageIndex = 0;
  ViewState _viewState = ViewState.Idle;
  String city;
  String companyCode;

  @override
  void initState() {
    city = 'Select City';
    companyCode = '';
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _viewState = ViewState.Loading;
  //     });
  //     DataConnectionChecker().connectionStatus.catchError((err) {
  //       print(err.toString());
  //       setState(() {
  //         _viewState = ViewState.Error;
  //         return _viewState;
  //       });
  //     }).then((connection) {
  //       if (connection == DataConnectionStatus.disconnected) {
  //         return setState(() {
  //           _viewState = ViewState.ConnectionError;
  //         });
  //       } else {
  //         // final selectedCafeteriaId =
  //         //     Provider.of<SelectedCafeteria>(context, listen: false).cafeId;
  //         // Provider.of<CafeteriaProvider>(context, listen: false)
  //         //     .getSelectedCafe(selectedCafeteriaId)
  //         //     .catchError((err) {
  //         //   print('error cafeteria screen - get cities/ selected cafe' +
  //         //       err.toString());
  //         //   return setState(() {
  //         //     _viewState = ViewState.Error;
  //         //   });
  //         // }).then((_) {
  //         final provider =
  //             Provider.of<CafeteriaProvider>(context, listen: false);
  //         if (provider.selectedCafeteria == null) {
  //           // companyCode = provider.selectedCafeteria.companyCode.toString();
  //           // city = provider.selectedCafeteria.city;
  //           // provider.getCompany(companyCode).catchError((err) {
  //           //   print('error cafeteria screen - get company' + err.toString());
  //           //   return setState(() {
  //           //     _viewState = ViewState.Error;
  //           //   });
  //           // }).then((_) {

  //           final provider1 =
  //               Provider.of<CafeteriaProvider>(context, listen: false);
  //           if (provider1.cafes.isEmpty) {
  //             provider1.getCafes('Montreal').catchError((err) {
  //               print('error cafeteria screen - get company' + err.toString());
  //               return setState(() {
  //                 _viewState = ViewState.Error;
  //               });
  //             }).then((_) {
  //               setState(() {
  //                 _viewState = ViewState.Idle;
  //                 _isInit = false;
  //               });
  //               return;
  //             });
  //           } else {
  //             setState(() {
  //               _viewState = ViewState.Idle;
  //               _isInit = false;
  //             });
  //             return;
  //           }
  //         }
  //         // } else {
  //         //   setState(() {
  //         //     _viewState = ViewState.Idle;
  //         //     _isInit = false;
  //         //   });
  //         //   return;
  //         // }
  //         // });
  //       }
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    bool isTab = DeviceService().isTablet(context);
    User user = FirebaseAuth.instance.currentUser;
    if (_viewState == ViewState.ConnectionError)
      return ErrorConnectionPage(routeName: CafeteriaSelectionScreen.routeName);
    if (_viewState == ViewState.Error)
      return ErrorPage(routeName: CafeteriaSelectionScreen.routeName);
    else {
      return MultiProvider(
        providers: [
          StreamProvider(
              initialData: ConnectivityStatus.Connected,
              create: (ctx) =>
                  ConnectivityService().connectionStatusController.stream),
          StreamProvider(
            create: (ctx) => UserService().getUserData(user.uid),
            initialData: const Loading1(),
            catchError: (_, error) => Error1(error.toString()),
          )
        ],
        child: Consumer<ConnectivityStatus>(
          builder: (ctx, connectionStatus, ch) => (connectionStatus ==
                  ConnectivityStatus.None)
              ? ErrorConnectionPage(
                  routeName: CafeteriaSelectionScreen.routeName)
              : Consumer<UserData>(builder: (ctx, data, ch) {
                  final cafeteriaProvider =
                      Provider.of<CafeteriaProvider>(context);
                  // Cafeteria selectedCafeteria = cafeteriaProvider.selectedCafeteria;
                  List<Cafeteria> cafes = cafeteriaProvider.cafes;
                  if (data is Loading1) {
                    return LoadingPage();
                  } else if (data is Error1) {
                    print(Error1(data.errorMsg));
                    return ErrorPage(
                        routeName: CafeteriaSelectionScreen.routeName);
                  } else if (data is UserDoc) {
                    UserDoc userData = data;
                    var size = MediaQuery.of(context).size;
                    return SafeArea(
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        body: Column(children: [
                          Container(
                            width: size.width,
                            height: size.height * 0.15,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 2,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    return SizedBox(
                                      width: 10.0,
                                    );
                                  }
                                  return Container(
                                    margin: EdgeInsets.all(5.0),
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0, 2),
                                            blurRadius: 6.0)
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen()));
                                      },
                                      child: CircleAvatar(
                                        child: ClipOval(
                                          child: Image(
                                              height: 70.0,
                                              width: 70.0,
                                              image: NetworkImage(userStory['profileImageUrl']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 4.0),
                          //   width: MediaQuery.of(context).size.width - 30,
                          //   height: 120.0,
                          //   decoration: BoxDecoration(
                          //       color: Colors.black12,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(10.0))),
                          //   child: Center(
                          //     child: Text("TBD"),
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                          //   width: MediaQuery.of(context).size.width - 30,
                          //   height: 50.0,
                          //   decoration: BoxDecoration(
                          //       color: Colors.black12,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(10.0))),
                          //   child: Center(
                          //     child: Text("Search Bar"),
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                          //   width: MediaQuery.of(context).size.width - 30,
                          //   height: 30.0,
                          //   decoration: BoxDecoration(
                          //       color: Colors.black12,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(10.0))),
                          //   child: Center(
                          //     child: Text("Filters"),
                          //   ),
                          // ),
                          Expanded(
                              child: StaggeredGridView.countBuilder(
                            padding: const EdgeInsets.all(4.0),
                            crossAxisCount: 4,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            itemCount: cafes.length,
                            itemBuilder: (BuildContext context, int index) =>
                                CafeteraCard(cafes[index], userData),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(2),
                          )),
                        ]),
                      ),
                    );
                  } else {
                    print('Cafe selection screen consumer userDoc error');
                    return Container();
                  }

                  // child: Scaffold(
                  //   appBar: AppBar(
                  //     title: Text('Select Cafeteria from'),
                  //   ),
                  //   body: Padding(
                  //     padding: const EdgeInsets.fromLTRB(12, 0, 10, 5),
                  //     child: ListView(
                  //     children: [
                  //       if (selectedCafeteria != null)
                  //         ListTile(
                  //           title: Text(
                  //             'Current Cafeteria',
                  //             style: Theme.of(context).textTheme.headline6,
                  //           ),
                  //           dense: true,
                  //         ),
                  //         if (selectedCafeteria != null)
                  //         CafeteriaDetails(cafe: selectedCafeteria,oldCafe: selectedCafeteria),
                  //         Divider(),
                  //         ListTile(
                  //           title: Text(
                  //             'Search Cafeteria',
                  //             style: Theme.of(context).textTheme.headline6,
                  //           ),
                  //           dense: true,
                  //         ),
                  //         Divider(),
                  //          Container(
                  //            margin: EdgeInsets.all(12),
                  //            child: StaggeredGridView.countBuilder(
                  //             padding: const EdgeInsets.all(12.0),
                  //             crossAxisCount: 4,
                  //             mainAxisSpacing: 24,
                  //             crossAxisSpacing: 12,
                  //             itemCount: cafes.length,
                  //             itemBuilder: (BuildContext context, int index) => CafeteraCard(cafes[index]),
                  //             staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  //         ))
                  //       ],
                  //   ),

                  // )
                  // );
                }),
        ),
      );
    }
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(color: Colors.white10),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(iconItems.length, (index) {
                return GestureDetector(
                    onTap: () {
                      pageIndex = index;
                      print(RouteNames[index]);
                      return null;
                    },
                    child: Column(children: [
                      iconItems[index],
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        textItems[index],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      )
                    ]));
              }),
            )));
  }
}

// @override
// Widget build(BuildContext context) {
//   bool isTab = DeviceService().isTablet(context);
//   if (_viewState == ViewState.ConnectionError)
//     return ErrorConnectionPage(routeName: CafeteriaSelectionScreen.routeName);
//   if (_viewState == ViewState.Error)
//     return ErrorPage(routeName: CafeteriaSelectionScreen.routeName);
//   else {
//     return MultiProvider(
//       providers: [
//         StreamProvider(
//             initialData: ConnectivityStatus.Connected,
//             create: (ctx) =>
//                 ConnectivityService().connectionStatusController.stream),
//       ],
//       child:
//           Consumer<ConnectivityStatus>(builder: (ctx, connectionStatus, ch) {
//         if (connectionStatus == ConnectivityStatus.None) {
//           return ErrorConnectionPage(
//               routeName: CafeteriaSelectionScreen.routeName);
//         } else {
//           if (_viewState == ViewState.Loading)
//             return LoadingPage();
//           else {
//             final cafeteriaProvider = Provider.of<CafeteriaProvider>(context);
//             Cafeteria selectedCafeteria = cafeteriaProvider.selectedCafeteria;
//             // Company company = cafeteriaProvider.company;
//             List<Cafeteria> cafes = cafeteriaProvider.cafes;
//             return SafeArea(
//               child: Scaffold(
//                 appBar: AppBar(
//                   title: Text('Select Cafeteria'),
//                 ),
//                 body: Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//                   child: ListView(
//                     children: [
//                       if (selectedCafeteria != null)
//                         ListTile(
//                           title: Text(
//                             'Current Cafeteria',
//                             style: Theme.of(context).textTheme.headline6,
//                           ),
//                           dense: true,
//                         ),
//                       if (selectedCafeteria != null)
//                         CafeteriaDetails(cafe: selectedCafeteria,oldCafe: selectedCafeteria),
//                       Divider(),
//                       ListTile(
//                         title: Text(
//                           'Search Cafeteria',
//                           style: Theme.of(context).textTheme.headline6,
//                         ),
//                         dense: true,
//                       ),
//                       // ListTile(
//                       //   title: TextFormField(
//                       //     key: ValueKey('number'),
//                       //     inputFormatters: [
//                       //       FilteringTextInputFormatter.digitsOnly
//                       //     ],
//                       //     initialValue: companyCode,
//                       //     onChanged: (val) async {
//                       //       //                               FirebaseCrashlytics.instance.setUserIdentifier("12345");
//                       //       // FirebaseCrashlytics.instance
//                       //       //     .log("Higgs-Boson detected! Bailing out");
//                       //       // FirebaseCrashlytics.instance.crash();
//                       //       setState(() {
//                       //         companyCode = val;
//                       //         if (companyCode.length == 4) {
//                       //           _loading = true;
//                       //           FocusScope.of(context).unfocus();
//                       //         }
//                       //       });
//                       //       if (companyCode.length == 4) {

//                       //         Dialogs.showLoadingDialog(context);
//                       //         try {
//                       //           print("trying to get company 4");
//                       //           // await cafeteriaProvider
//                       //           //     .getCompany(companyCode);
//                       //         } catch (exception, stackTrace) {
//                       //           // await Sentry.captureException(
//                       //           //   exception,
//                       //           //   stackTrace: stackTrace,
//                       //           // );

//                       //           Navigator.of(context).pop();
//                       //           Navigator.of(context).pushReplacementNamed(
//                       //               CafeteriaSelectionScreen.routeName);
//                       //         }

//                       //         Navigator.of(context).pop();
//                       //         setState(() {
//                       //           _loading = false;
//                       //         });
//                       //       } else if (companyCode.length == 3) {
//                       //         // cafeteriaProvider.setCompanyToEmpty();
//                       //         print("trying to get company 3");
//                       //         setState(() {city = 'Select City';
//                       //         });
//                       //       }
//                       //     },
//                       //     keyboardType: TextInputType.number,
//                       //     maxLength: 4,
//                       //     decoration: InputDecoration(
//                       //       labelText: 'Company Code',
//                       //       hintText: 'Enter Company Code',
//                       //       border: OutlineInputBorder(
//                       //         borderRadius: BorderRadius.circular(10.0),
//                       //         borderSide: BorderSide(),
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       // if (companyCode.length == 4 &&
//                       //     company == null &&
//                       //     !_loading)
//                       //   ListTile(
//                       //     title: Text('Incorrect Company Code',
//                       //         style: TextStyle(
//                       //           color: Theme.of(context).errorColor,
//                       //         )),
//                       //   ),
//                       // if (company != null && company.cities.length > 1)
//                       //   Padding(
//                       //     padding: const EdgeInsets.fromLTRB(14.0, 8, 14, 8),
//                       //     child: Container(
//                       //       decoration: BoxDecoration(
//                       //           color: Colors.grey[50],
//                       //           border: Border.all(
//                       //             color: Colors.grey[200],
//                       //           ),
//                       //           shape: BoxShape.rectangle,
//                       //           borderRadius:
//                       //               BorderRadius.all(Radius.circular(10))),
//                       //       child: Padding(
//                       //         padding:
//                       //             const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
//                       //         child: ListTile(
//                       //             title: TextFormField(
//                       //               initialValue: company.name,
//                       //               enabled: false,
//                       //               decoration: InputDecoration(
//                       //                 labelText: 'Company Name',
//                       //                 border: InputBorder.none,
//                       //               ),
//                       //             ),
//                       //             subtitle: DropdownButtonFormField<String>(
//                       //               isExpanded: true,
//                       //               isDense: isTab == false,
//                       //               value: city,
//                       //               decoration: InputDecoration(
//                       //                 floatingLabelBehavior:
//                       //                     FloatingLabelBehavior.always,
//                       //                 labelText: 'Select City',
//                       //                 border: OutlineInputBorder(
//                       //                   borderRadius:
//                       //                       BorderRadius.circular(20),
//                       //                 ),
//                       //               ),
//                       //               onChanged: (String value) async {
//                       //                 setState(() {
//                       //                   city = value;
//                       //                 });
//                       //                 if (city == 'Select City') {
//                       //                   cafeteriaProvider.setCafesToEmpty();
//                       //                 } else {
//                       //                   Dialogs.showLoadingDialog(context);
//                       //                   await cafeteriaProvider.getCafes(
//                       //                       city, company.id);
//                       //                   Navigator.of(context).pop();
//                       //                 }
//                       //               },
//                       //               items: company.cities
//                       //                   .map(
//                       //                     (String city) =>
//                       //                         DropdownMenuItem<String>(
//                       //                       child: (city == 'Select City')
//                       //                           ? Text(
//                       //                               city,
//                       //                               style: TextStyle(
//                       //                                   fontStyle:
//                       //                                       FontStyle.italic,
//                       //                                   color:
//                       //                                       Colors.black54),
//                       //                             )
//                       //                           : Text(city),
//                       //                       value: city,
//                       //                     ),
//                       //                   )
//                       //                   .toList(),
//                       //             )),
//                       //       ),
//                       //     ),
//                       //   ),
//                       // if (company != null && company.cities.length == 1)
//                       //   Padding(
//                       //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
//                       //     child: ListTile(
//                       //       title: TextFormField(
//                       //           initialValue: company.name,
//                       //           enabled: false,
//                       //           decoration: InputDecoration(
//                       //             filled: true,
//                       //             enabled: false,
//                       //             labelText: 'Company Name',
//                       //             fillColor: Colors.grey[100],
//                       //             labelStyle: TextStyle(
//                       //                 backgroundColor: Colors.grey[100]),
//                       //           )),
//                       //     ),
//                       //   ),
//                       // if (cafes.length >= 1)
//                       //   ListView.builder(
//                       //     shrinkWrap: true,
//                       //     physics: NeverScrollableScrollPhysics(),
//                       //     itemCount: cafes.length,
//                       //     itemBuilder: (ctx, i) => Padding(
//                       //       padding:
//                       //           const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
//                       //       child: CafeteriaDetails(
//                       //           cafe: cafes[i], oldCafe: selectedCafeteria),
//                       //     ),
//                       //   ),
//                     ],
//                   ),
//                 ),
//                 floatingActionButtonLocation:
//                     FloatingActionButtonLocation.centerFloat,
//                 floatingActionButton: DemoButton(
//                   cafe: selectedCafeteria,
//                 ),
//               ),
//             );
//           }
//         }
//       }),
//     );
//   }
// }

class DemoButton extends StatelessWidget {
  final Cafeteria cafe;
  const DemoButton({Key key, this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        'Scan the Cafe',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          // color: Theme.of(context).primaryColor
        ),
      ),
      onPressed: () {
        //  Dialogs.showLoadingDialog(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QRScannerScan(
                  cafe: cafe,
                )));

        // Cafeteria testCafe = await CafeteriasService().getCafeteriaByCode();
        // try {
        //   if (testCafe == null) {
        //     Navigator.of(context).pop();
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text('Test Cafeteria not active'),
        //     ));
        //   } else {
        //     final user = FirebaseAuth.instance.currentUser;
        //     final userId = user.uid;
        //     await DatabaseHelper().clearLocalCart();
        //     Provider.of<CartProvider>(context, listen: false)
        //         .clearProviderCart();
        //     await CartService().clearCart(userId);
        //     await UserService()
        //         .addCafeToUser(userId, testCafe.id, testCafe.companyId);
        //     await NotificationService().selectCafeSubcribe(
        //         testCafe.id, testCafe.companyId, testCafe.city);
        //     Provider.of<SelectedCafeteria>(context, listen: false).setCafeteria(
        //         testCafe.id, testCafe.name, testCafe.city, testCafe.companyId);
        //     Navigator.of(context).pop();

        //     return Navigator.of(context)
        //         .pushReplacementNamed(VendorListScreen.routeName);
        //   }
        // } catch (err) {
        //   print('error Cafe selection screen - pvt fucntion select cafe = ' +
        //       err.toString());
        //   throw (err);
        // }
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:freemeals/models/cafe_model.dart';
// import 'package:freemeals/widgets/cafeteria_card.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class CafeteriaSelection extends StatelessWidget {

//   static const routeName = '/cafe-selection';

//   final cafeList = [];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white24,
//         body: Container(
//           margin: EdgeInsets.all(12),
//           child:  StaggeredGridView.countBuilder(
//           padding: const EdgeInsets.all(12.0),
//           crossAxisCount: 4,
//           mainAxisSpacing: 24,
//           crossAxisSpacing: 12,
//           itemCount: cafeList.length,
//           itemBuilder: (BuildContext context, int index) => CafeteraCard(cafeList[index]),
//           staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
//         ),
//               ),
//           ),
//     );
// }}
