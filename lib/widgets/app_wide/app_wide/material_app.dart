import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:freemeals/config/environment_config.dart';
import 'package:freemeals/handle_main.dart';
import 'package:freemeals/providers/cafeteria_provider.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/Cafeteria/freemeals_splash_screen.dart';
import 'package:freemeals/screen/Cafeteria/waiter_selection_screen.dart';
import 'package:freemeals/screen/ErrorScreen/syncronized_error_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/util/theme.dart';
// import 'package:platos_client_app/handle_main.dart';
// import 'package:platos_client_app/providers/cafeteria_provider.dart';
// import 'package:platos_client_app/screens/account_info_screen.dart';
// import 'package:platos_client_app/screens/auth_screen.dart';
// import 'package:platos_client_app/screens/cafeteria_selection_screen.dart';
// import 'package:platos_client_app/screens/cart_screen.dart';
// import 'package:platos_client_app/screens/error_connection_screen.dart';
// import 'package:platos_client_app/screens/error_screen.dart';
// import 'package:platos_client_app/screens/faqs_screen.dart';
// import 'package:platos_client_app/screens/favorite_screen.dart';
// import 'package:platos_client_app/screens/name_screen.dart';
// import 'package:platos_client_app/screens/order_offline_screen.dart';
// import 'package:platos_client_app/screens/order_screen.dart';
// import 'package:platos_client_app/screens/platos_splash_screen.dart';
// import 'package:platos_client_app/screens/search_screen.dart';
// import 'package:platos_client_app/screens/syncronized_error_screen.dart';
// import 'package:platos_client_app/screens/vendor_item_screen.dart';
// import 'package:platos_client_app/screens/vendor_list_screen.dart';
// import 'package:platos_client_app/util/theme.dart';

class MatApp extends StatelessWidget {
  final bool initialized;
  final bool error;
  final SelectedCafeteria selectCafe;
  const MatApp({Key key, this.initialized, this.error, this.selectCafe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: EnvironmentConfig.APP_MODE == 'prod'
          ? 'Platos'
          : EnvironmentConfig.APP_MODE == 'dev'
              ? 'Platos Dev'
              : 'Platos Test',
      theme: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .size
                  .shortestSide <
              600
          ? PhoneGalleryThemeData.lightThemeData
          : TabletGalleryThemeData.lightThemeData,
      home: (error)
          ? SyncronizedErrorScreen()
          : (!initialized)
              ? FreeMealsSplashScreen() : HandleMain(selectCafe: selectCafe),
      routes: {
        // VendorListScreen.routeName: (ctx) => VendorListScreen(),
        // VendorItemScreen.routeName: (ctx) => VendorItemScreen(),
        // CartScreen.routeName: (ctx) => CartScreen(),
        // OrdersScreen.routeName: (ctx) => OrdersScreen(),
        // FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
        CafeteriaSelectionScreen.routeName: (ctx) => CafeteriaSelectionScreen(),
        DiscoverPage.routeName : (ctx) => DiscoverPage(),
        WaiterSelectionScreen.routeName : (ctx) => WaiterSelectionScreen(waiterSelection: null,),
        // AuthScreen.routeName: (ctx) => AuthScreen(),
        // SearchScreen.routeName: (ctx) => SearchScreen(),
        // AccountInfoScreen.routeName: (ctx) => AccountInfoScreen(),
        // OrderOfflineScreen.routeName: (ctx) => OrderOfflineScreen(),
        // ErrorScreen.routeName: (ctx) => ErrorScreen(),
        // ConnectionErrorScreen.routeName: (ctx) => ConnectionErrorScreen(),
        // NameScreen.routeName: (ctx) => NameScreen(),
        // FAQsScreen.routeName: (ctx) => FAQsScreen(),
      },
    );
  }
}
