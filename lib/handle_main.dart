import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/cafeteria_provider.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/Cafeteria/cafeteria_splash_screen.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/Cafeteria/freemeals_splash_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/name_screen.dart';
import 'package:freemeals/screen/root_app.dart';
import 'package:freemeals/screen/version_check_screen.dart';
import 'package:freemeals/services/cafeteria_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/services/version_service.dart';

// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/providers/cafeteria_provider.dart';
// import 'package:platos_client_app/screens/auth_screen.dart';
// import 'package:platos_client_app/screens/cafeteria_selection_screen.dart';
// import 'package:platos_client_app/screens/cafeteria_splash_screen.dart';
// import 'package:platos_client_app/screens/name_screen.dart';
// import 'package:platos_client_app/screens/platos_splash_screen.dart';
// import 'package:platos_client_app/screens/version_check_screen.dart';
// import 'package:platos_client_app/services/cafeteria_service.dart';
// import 'package:platos_client_app/services/version_service.dart';

class HandleMain extends StatelessWidget {
  final SelectedCafeteria selectCafe;
  const HandleMain({Key key, this.selectCafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
        future: VersionService().versionStable(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return FreeMealsSplashScreen();
          else {
            if (snapshot.hasData) {
              bool versionCheck = snapshot.data;

              if (versionCheck) {
                if (user == null) {
                  // return AuthScreen();
                  return RootApp();
                } else if (user.displayName == null ||
                    user.displayName.isEmpty ||
                    user.email == null ||
                    user.email.isEmpty) {
                  print("name screen");
                  return NameScreen();
                } else if (selectCafe.cafeId == null ||
                        selectCafe.cafeName == null ||
                        selectCafe.city == null
                    ) {
                  return FutureBuilder(
                      future: UserService().getUserByID(user.uid),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return FreeMealsSplashScreen();
                        else {
                          if (snapshot.hasData) {
                            return RootApp(user: UserDoc.fromDoctoUserInfo(snapshot.data));
                          } else {
                            print('Error - get user, handle main');
                            return RootApp();
                          }
                        }
                      });
                } else {
                  return FutureBuilder(
                      future: CafeteriasService().getCafeteriaByID(selectCafe.cafeId),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return FreeMealsSplashScreen();
                        else {
                          if (snapshot.hasData) {
                            return CafeteriaSplashScreen(cafe: snapshot.data);
                          } else {
                            print('Error - get Cafe');
                            // return CafeteriaSelectionScreen();
                            return RootApp(user: UserDoc.fromDoctoUserInfo(snapshot.data));
                          }
                        }
                      });
                }
              } else {
                return VersionCheckScreen();
              }
            } else {
              print('Error - version check');
              if (user == null)
                // return AuthScreen();
                return RootApp();
              else if (user.displayName == null ||
                  user.displayName.isEmpty ||
                  user.email == null ||
                  user.email.isEmpty)
                return NameScreen();
              else if (selectCafe.cafeId == null ||
                      selectCafe.cafeName == null ||
                      selectCafe.city == null
                  // selectCafe.companyId == null
                  )
                return CafeteriaSelectionScreen();
              else {
                return FutureBuilder(
                    future:
                        CafeteriasService().getCafeteriaByID(selectCafe.cafeId),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return FreeMealsSplashScreen();
                      else {
                        if (snapshot.hasData) {
                          Cafeteria cafe = snapshot.data;
                          return CafeteriaSplashScreen(cafe: cafe);
                        } else {
                          print('Error - get Cafe');
                          return CafeteriaSelectionScreen();
                        }
                      }
                    });
              }
            }
          }
        });
  }
}
