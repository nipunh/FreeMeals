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
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: MultiProvider(
                providers: [
          StreamProvider(
              initialData: ConnectivityStatus.Connected,
              create: (ctx) =>
                  ConnectivityService().connectionStatusController.stream),
        ],
                child: Consumer<ConnectivityStatus>(
                    // ignore: missing_return
                    builder: (ctx, connectionStatus, ch) {
                  if (connectionStatus == ConnectivityStatus.None) {
                    ErrorConnectionPage(
                        routeName: WaiterSelectionScreen.routeName);
                  } else {
                    final waiterProvider = Provider.of<WaiterProvider>(context);
                    waiterProvider.getWaiters("CXdKnqsdwetprt885KVx");
                    List<UserData> selectedWaiter = waiterProvider.waiters;
                    return SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text('Select your server'),
                        ),
                        body: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.black,
                                ),
                            itemCount: selectedWaiter.length,
                            itemBuilder: (BuildContext context, int index) {
                              UserDoc waiter = selectedWaiter.elementAt(index);
                              return new Column(
                                children: <Widget>[
                                  new ListTile(
                                    enabled: waiter.status == 0 ? true : false,
                                    onTap: () {
                                      UserService().selectWaiter(waiter.id, 1);
                                    },
                                    leading: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: waiter.profileImageUrl,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    ),
                                    title: new Text(waiter.displayName),
                                    subtitle: Text(waiter.caption),
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  }
                }))));
  }
}