import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freemeals/config/stories_data.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/providers/cafeteria_provider.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/screen/Order/OrderWaitingScreen.dart';
import 'package:freemeals/screen/Order/ongoingOrder_screen.dart';
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
            child: SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.grey[200],
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(
                        color: Colors.white,
                        size: 28,
                        //change your color here
                      ),
                    ),
                    body: Container(
                      child: MultiProvider(
                        providers: [
                          StreamProvider(
                              initialData: ConnectivityStatus.Connected,
                              create: (ctx) => ConnectivityService()
                                  .connectionStatusController
                                  .stream),
                        ],
                        child: Consumer<ConnectivityStatus>(
                            builder: (ctx, connectionStatus, ch) {
                          if (connectionStatus == ConnectivityStatus.None) {
                            return ErrorConnectionPage(
                                routeName: WaiterSelectionScreen.routeName);
                          } else {
                            if (_viewState == ViewState.Loading)
                              return LoadingPage();
                            else {
                              String cafeId = Provider.of<SelectedCafeteria>(
                                      context,
                                      listen: false)
                                  .cafeId;
                              final waiterProvider =
                                  Provider.of<WaiterProvider>(context);
                              waiterProvider.getWaiters(cafeId);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ColumnSuper(
                                    innerDistance: -size.height * 0.1,
                                    invert: false,
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: size.height * 0.40,
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        padding: EdgeInsets.only(bottom: 25),
                                        //ClipRRect for image border radius
                                        child: ClipRRect(
                                            child: Image.network(
                                          "https://firebasestorage.googleapis.com/v0/b/freemeals-3d905.appspot.com/o/cafeterias%2FCXdKnqsdwetprt885KVx%2FofferBanners%2Ffood-offer-banner.jpg?alt=media&token=d966d3aa-d0cc-4dae-bc8f-0b75a8943d47",
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                      Container(
                                        height: size.height * 0.125,
                                        width: size.width * 0.95,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.025),
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              colors: [
                                                Color(0xff171717),
                                                Color(0xff171717),
                                              ],
                                            )),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "Connect with your server",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                  )),
                                              TextSpan(text: "\n"),
                                              TextSpan(
                                                  text: "and begin your order ",
                                                  style:
                                                      TextStyle(fontSize: 22)),
                                              TextSpan(
                                                  text: "Live!",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          //ClipRRect for image border radius
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        padding: EdgeInsets.only(right: 7.5),
                                        margin: EdgeInsets.all(0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          // ignore: deprecated_member_use
                                          // overflow: Overflow.visible,
                                          children: <Widget>[
                                            new Positioned(
                                              left: -5,
                                              top: -7.5,
                                              child: Icon(
                                                Icons.check_circle_rounded,
                                                size: 45,
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 38.0),
                                              child: Text("7th Meal Free",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            )
                                          ],
                                        ),
                                        height: 35,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                          color:
                                              Color.fromRGBO(132, 82, 161, 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        )),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         Container(
                                  //             padding:
                                  //                 EdgeInsets.only(right: 10),
                                  //             margin: EdgeInsets.all(0),
                                  //             alignment: Alignment.topLeft,
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceBetween,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.center,
                                  //               children: [
                                  //                 Icon(
                                  //                   Icons.check_circle,
                                  //                   size: 30,
                                  //                   color: Colors.white,
                                  //                 ),
                                  //                 Text("7th Meal Free",
                                  //                     style: TextStyle(
                                  //                         color: Colors.white))
                                  //               ],
                                  //             ),
                                  //             height: 30,
                                  //             width: 140,
                                  //             decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.all(
                                  //                   Radius.circular(20)),
                                  //               border: Border.all(
                                  //                 width: 2,
                                  //                 color: Colors.white54,
                                  //               ),
                                  //               color: Color.fromRGBO(
                                  //                   132, 82, 161, 1),
                                  //               boxShadow: [
                                  //                 BoxShadow(
                                  //                   color: Colors.grey
                                  //                       .withOpacity(0.5),
                                  //                   spreadRadius: 2,
                                  //                   blurRadius: 5,
                                  //                   offset: Offset(0,
                                  //                       3), // changes position of shadow
                                  //                 ),
                                  //               ],
                                  //             )),
                                  //       ]),
                                  // ),
                                  Expanded(
                                      // decoration: BoxDecoration(color: Colors.blue),
                                      child: StaggeredGridView.countBuilder(
                                    padding: const EdgeInsets.all(4.0),
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    itemCount: waiterProvider.waiters.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      UserDoc waiter = waiterProvider.waiters
                                          .elementAt(index);
                                      return new Column(
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              ColumnSuper(
                                                  innerDistance: -20,
                                                  invert: false,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Material(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      type: MaterialType.circle,
                                                      color: Colors.transparent,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          UserService()
                                                              .createOrder(user)
                                                              .then((OrderDoc
                                                                  value) {
                                                            // print("******/
                                                            Navigator.push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            new OrderWaitingScreen(
                                                                              user: user,
                                                                              orderCode: value.orderId,
                                                                              orderDocId: value.id,
                                                                              cafeId: value.cafeId,
                                                                            )));
                                                          });

                                                          // _settingModalBottomSheet(
                                                          //     context,
                                                          //     value,
                                                          //     " waiter.id");
                                                          //   Navigator.push(
                                                          //       context,
                                                          //       new MaterialPageRoute(
                                                          //           builder:
                                                          //               (context) =>
                                                          //                   new OngoingOrder()));
                                                          // });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          new Radius.circular(
                                                                              32.5)),
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                  )),
                                                          child: CircleAvatar(
                                                            minRadius: 65,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            child:
                                                                CachedNetworkImage(
                                                              height: 140,
                                                              width: 130.0,
                                                              imageUrl: waiter
                                                                  .profileImageUrl,
                                                              fit: BoxFit.cover,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  new CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  new Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 60),
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                        .yellow[
                                                                    600],
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        new Radius.circular(
                                                                            10))),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "4",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white54),
                                                                  ),
                                                                  Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  )
                                                                ])))
                                                  ]),
                                              Text(
                                                "${waiter.displayName}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                    staggeredTileBuilder: (int index) =>
                                        StaggeredTile.fit(2),
                                  ))
                                ],
                              );
                            }
                          }
                        }),
                      ),
                    )))));
  }
}
