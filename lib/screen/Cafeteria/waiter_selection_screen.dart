import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freemeals/config/stories_data.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/screen/UserProfile/profile_widget.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/AlertDialogBox.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:ui' as ui;
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class WaiterSelectionScreen extends StatefulWidget {
  static String routeName = '/waiter-selection-screen';

  final WaiterSelection waiterSelection;

  WaiterSelectionScreen({Key key, @required this.waiterSelection})
      : super(key: key);

  @override
  _WaiterSelectionScreenState createState() => _WaiterSelectionScreenState();
}

class _WaiterSelectionScreenState extends State<WaiterSelectionScreen> {
  bool _isInit = true;
  ViewState _viewState = ViewState.Idle;
  List<UserData> waiters = [];
  bool isLoading = true;
  String ongoingOrderId = "";

  void _settingModalBottomSheet(context, ongoinOrderId, currWaiterId) {
    int _currentHorizontalIntValue = 1;
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: false,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            height: size.height * 0.35,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Awaiting Waiter Confirmation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          height: 60,
                          width: 60)
                      : Icon(Icons.check_circle_outline_outlined,
                          size: 30, color: Colors.greenAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: AlertDialogBox(
                    text:
                        "Would you like to cancel this request and choose other server?",
                    orderId: ongoingOrderId,
                    waiterId: currWaiterId,
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: MultiProvider(
          providers: [
            StreamProvider(
                initialData: ConnectivityStatus.Connected,
                create: (ctx) =>
                    ConnectivityService().connectionStatusController.stream),
            StreamProvider(
              create: (ctx) => UserService().getWaiters("CXdKnqsdwetprt885KVx"),
              initialData: const Loading1(),
              catchError: (_, error) => Error1(error.toString()),
            ),
            // StreamProvider(
            //   create: (ctx) =>
            //       UserService().getOfferBanners("CXdKnqsdwetprt885KVx"),
            //   initialData: const Loading1(),
            //   catchError: (_, error) => Error1(error.toString()),
            // ),
          ],
          child: Consumer<ConnectivityStatus>(
            builder: (ctx, connectionStatus, ch) => 
            (connectionStatus == ConnectivityStatus.None)
                ? ErrorConnectionPage(
                    routeName: WaiterSelectionScreen.routeName)
                : Consumer<List<UserData>>(
                  builder: (ctx, data, ch) {
                    if (data is Loading1) {
                      return LoadingPage();
                    } else if (data is Error1) {
                      print(data);
                      return ErrorPage(
                          routeName: WaiterSelectionScreen.routeName);
                    } else if (data is UserData) {
                      return Container();
                      // SafeArea(
                      //   child: Scaffold(
                      //     backgroundColor: Colors.grey[200],
                      //     extendBodyBehindAppBar: true,
                      //     appBar: AppBar(
                      //       backgroundColor: Colors.transparent,
                      //       iconTheme: IconThemeData(
                      //         color: Colors.white,
                      //         size: 28,
                      //         //change your color here
                      //       ),
                      //     ),
                      //     body: Column(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: <Widget>[
                      //         ColumnSuper(
                      //           innerDistance: -size.height * 0.1,
                      //           invert: false,
                      //           alignment: Alignment.center,
                      //           children: [
                      //             Container(
                      //               height: size.height * 0.40,
                      //               decoration:
                      //                   BoxDecoration(color: Colors.white),
                      //               padding: EdgeInsets.only(bottom: 25),
                      //               //ClipRRect for image border radius
                      //               child: ClipRRect(
                      //                   child: Image.network(
                      //                 "imageList[0]",
                      //                 width: MediaQuery.of(context).size.width,
                      //                 fit: BoxFit.cover,
                      //               )),
                      //             ),
                      //             Container(
                      //               height: size.height * 0.125,
                      //               width: size.width * 0.80,
                      //               alignment: Alignment.center,
                      //               decoration: BoxDecoration(
                      //                   border: Border.all(color: Colors.white),
                      //                   borderRadius: BorderRadius.circular(
                      //                       size.height * 0.025),
                      //                   gradient: LinearGradient(
                      //                     begin: Alignment.bottomLeft,
                      //                     end: Alignment.topRight,
                      //                     colors: [
                      //                       Color(0xff171717),
                      //                       Color(0xff171717),
                      //                     ],
                      //                   )),
                      //               child: RichText(
                      //                 text: TextSpan(
                      //                   children: [
                      //                     TextSpan(
                      //                         text: "Connect with your server",
                      //                         style: TextStyle(
                      //                           fontSize: 18,
                      //                         )),
                      //                     TextSpan(text: "\n"),
                      //                     TextSpan(
                      //                         text: "and begin your order ",
                      //                         style: TextStyle(fontSize: 18)),
                      //                     TextSpan(
                      //                         text: "Live!",
                      //                         style: TextStyle(
                      //                             fontSize: 18,
                      //                             fontWeight: FontWeight.bold))
                      //                   ],
                      //                 ),
                      //                 //ClipRRect for image border radius
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Container(
                      //                     padding: EdgeInsets.only(right: 10),
                      //                     margin: EdgeInsets.all(0),
                      //                     alignment: Alignment.topLeft,
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.center,
                      //                       children: [
                      //                         Icon(
                      //                           Icons.check_circle,
                      //                           size: 30,
                      //                           color: Colors.white,
                      //                         ),
                      //                         Text("7th Meal Free",
                      //                             style: TextStyle(
                      //                                 color: Colors.white))
                      //                       ],
                      //                     ),
                      //                     height: 30,
                      //                     width: 140,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.all(
                      //                           Radius.circular(20)),
                      //                       border: Border.all(
                      //                         width: 2,
                      //                         color: Colors.white54,
                      //                       ),
                      //                       color:
                      //                           Color.fromRGBO(132, 82, 161, 1),
                      //                       boxShadow: [
                      //                         BoxShadow(
                      //                           color: Colors.grey
                      //                               .withOpacity(0.5),
                      //                           spreadRadius: 2,
                      //                           blurRadius: 5,
                      //                           offset: Offset(0,
                      //                               3), // changes position of shadow
                      //                         ),
                      //                       ],
                      //                     )),
                      //               ]),
                      //         ),
                      //         Divider(),
                      //         Expanded(
                      //             // decoration: BoxDecoration(color: Colors.blue),
                      //             child: StaggeredGridView.countBuilder(
                      //           padding: const EdgeInsets.all(4.0),
                      //           crossAxisCount: 4,
                      //           mainAxisSpacing: 4,
                      //           crossAxisSpacing: 4,
                      //           itemCount: 0,
                      //           // selectedWaiter.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             // UserDoc waiter = selectedWaiter.elementAt(index);
                      //             return new Column(
                      //               children: <Widget>[
                      //                 Column(
                      //                   children: [
                      //                     ColumnSuper(
                      //                         innerDistance: -20,
                      //                         invert: false,
                      //                         alignment: Alignment.center,
                      //                         children: [
                      //                           Material(
                      //                             clipBehavior: Clip.antiAlias,
                      //                             type: MaterialType.circle,
                      //                             color: Colors.transparent,
                      //                             child: GestureDetector(
                      //                               onTap: () {
                      //                                 UserService()
                      //                                     .selectWaiter(
                      //                                         "waiter.id",
                      //                                         0,
                      //                                         user)
                      //                                     .then((String value) {
                      //                                   setState(() {
                      //                                     ongoingOrderId =
                      //                                         value;
                      //                                   });
                      //                                   _settingModalBottomSheet(
                      //                                       context,
                      //                                       value,
                      //                                       " waiter.id");
                      //                                 });
                      //                               },
                      //                               child: Container(
                      //                                 decoration: BoxDecoration(
                      //                                     color: Colors.black,
                      //                                     borderRadius:
                      //                                         BorderRadius.all(
                      //                                             new Radius
                      //                                                     .circular(
                      //                                                 32.5)),
                      //                                     border: Border.all(
                      //                                       width: 3,
                      //                                     )),
                      //                                 child: CircleAvatar(
                      //                                   minRadius: 65,
                      //                                   backgroundColor:
                      //                                       Colors.grey[200],
                      //                                   child:
                      //                                       CachedNetworkImage(
                      //                                     height: 140,
                      //                                     width: 130.0,
                      //                                     imageUrl:
                      //                                         "waiter.profileImageUrl",
                      //                                     fit: BoxFit.cover,
                      //                                     placeholder: (context,
                      //                                             url) =>
                      //                                         new CircularProgressIndicator(),
                      //                                     errorWidget: (context,
                      //                                             url, error) =>
                      //                                         new Icon(
                      //                                             Icons.error),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           Padding(
                      //                               padding: EdgeInsets
                      //                                   .only(left: 60),
                      //                               child: Container(
                      //                                   alignment: Alignment
                      //                                       .center,
                      //                                   width: 40,
                      //                                   decoration: BoxDecoration(
                      //                                       color:
                      //                                           Colors
                      //                                                   .yellow[
                      //                                               600],
                      //                                       borderRadius:
                      //                                           BorderRadius.all(
                      //                                               new Radius
                      //                                                       .circular(
                      //                                                   10))),
                      //                                   child: Row(
                      //                                       mainAxisAlignment:
                      //                                           MainAxisAlignment
                      //                                               .center,
                      //                                       crossAxisAlignment:
                      //                                           CrossAxisAlignment
                      //                                               .center,
                      //                                       children: <Widget>[
                      //                                         Text(
                      //                                           "4",
                      //                                           style: TextStyle(
                      //                                               color: Colors
                      //                                                   .white54),
                      //                                         ),
                      //                                         Icon(
                      //                                           Icons.star,
                      //                                           color: Colors
                      //                                               .white,
                      //                                           size: 16,
                      //                                         )
                      //                                       ])))
                      //                         ]),
                      //                     Text(
                      //                       "{waiter.displayName}",
                      //                       style: TextStyle(
                      //                           fontSize: 16,
                      //                           fontStyle: FontStyle.italic),
                      //                     )
                      //                   ],
                      //                 )
                      //               ],
                      //             );
                      //           },
                      //           staggeredTileBuilder: (int index) =>
                      //               StaggeredTile.fit(2),
                      //         ))
                      //       ],
                      //     ),
                      //   ),
                      // );
                    }  else {
                      print("this else");
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    }
                  }),
          ),
        ),
      ),
    );
  }
}
