import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/providers/bookingTable_provider.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/screen/Order/cart_screen.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/notification_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/material_app.dart';
import 'enums/connectivity_status.dart';
import './providers/cafeteria_provider.dart';
import 'package:provider/provider.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      // used for notification when app is terminated - check vendor list screen
      await NotificationService.setNotificationBool(true);
      setState(() {
        _initialized = true;
      });
    } catch (err) {
      print('Error - Main - Firebase initialize = ' + err.toString());
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MatApp(initialized: _initialized, error: _error, selectCafe: null);
    }
    if (!_initialized) {
      return MatApp(initialized: _initialized, error: _error, selectCafe: null);
    }
    return MultiProvider(
      providers: [
        StreamProvider(
            initialData: ConnectivityStatus.Connected,
            create: (ctx) =>
        ConnectivityService().connectionStatusController.stream),
        ChangeNotifierProvider(create: (ctx) => CafeteriaProvider()),
        ChangeNotifierProvider(create: (ctx) => SelectedCafeteria()),
        ChangeNotifierProvider(create: (ctx) => WaiterProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => BookingRequestProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        // ChangeNotifierProvider(create: (ctx) => CartProvider()),
        // ChangeNotifierProvider(create: (ctx) => VegOnly()),
        // ChangeNotifierProvider(create: (ctx) => FavoritePageProvider()),
        // ChangeNotifierProvider(create: (ctx) => ItemGroupProvider()),
        // ChangeNotifierProvider(create: (ctx) => RatingProvider()),
      ],
      child: Consumer<SelectedCafeteria>(builder: (ctx, selectCafe, ch) {
        return MatApp(
          initialized: _initialized,
          error: _error,
          selectCafe: selectCafe,
        );
      }),
    );
  }
}

  // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Wrapper(),
//     );
//   }
// }

