import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:platos_client_app/providers/cafeteria_provider.dart';
// import 'package:platos_client_app/screens/auth_screen.dart';
// import 'package:platos_client_app/screens/cafeteria_selection_screen.dart';
// import 'package:platos_client_app/screens/name_screen.dart';
// import 'package:platos_client_app/screens/order_offline_screen.dart';
// import 'package:platos_client_app/screens/vendor_list_screen.dart';
import 'package:provider/provider.dart';

class SyncronizedErrorScreen extends StatelessWidget {
  static const routeName = '/sync-error';
  const SyncronizedErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            label: Text(
              'Recent Orders',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(OrderOfflineScreen.routeName);
            }),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.80,
                child: Image.asset('assets/images/error.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.headline2.fontWeight,
                    fontSize: Theme.of(context).textTheme.headline2.fontSize,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[100],
                    elevation: 3,
                  ),
                  child: Text('Go to Home'),
                  onPressed: () {
                    final cafeProvider =
                        Provider.of<SelectedCafeteria>(context, listen: false);
                    User user = FirebaseAuth.instance.currentUser;
                    if (user == null)
                      Navigator.of(context)
                          .pushReplacementNamed(AuthScreen.routeName);
                    else if (user.displayName == null ||
                        user.displayName.isEmpty ||
                        user.email == null ||
                        user.email.isEmpty)
                      Navigator.of(context)
                          .pushReplacementNamed(NameScreen.routeName);
                    else if (cafeProvider.cafeId == null ||
                        cafeProvider.cafeName == null ||
                        cafeProvider.city == null ||
                        cafeProvider.companyId == null)
                      return Navigator.of(context).pushReplacementNamed(
                          CafeteriaSelectionScreen.routeName);
                    else
                      Navigator.of(context)
                          .pushReplacementNamed(VendorListScreen.routeName);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
