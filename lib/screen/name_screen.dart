import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/services/auth_service.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NameScreen extends StatelessWidget {
  static const routeName = '/name';
  const NameScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      initialData: ConnectivityStatus.Connected,
      create: (ctx) => ConnectivityService().connectionStatusController.stream,
      child: Consumer<ConnectivityStatus>(
        builder: (ctx, connectionStatus, ch) =>
            (connectionStatus == ConnectivityStatus.None)
                ? ErrorConnectionPage(routeName: NameScreen.routeName)
                : SafeArea(
                    child: Scaffold(body: _NameScreenWidget()),
                  ),
      ),
    );
  }
}

class _NameScreenWidget extends StatefulWidget {
  const _NameScreenWidget({Key key}) : super(key: key);

  @override
  __NameScreenWidgetState createState() => __NameScreenWidgetState();
}

class __NameScreenWidgetState extends State<_NameScreenWidget> {
  bool _isLoading = false;
  bool isInit = true;
  String _name = '';
  String _email = '';
  // bool isError = false;
  String _errorText;
  RegExp mailRegex = RegExp(
      r'[a-z0-9!#$%&"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&"*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      User user = FirebaseAuth.instance.currentUser;
      isInit = false;
      setState(() {
        _name = user.displayName ?? '';
        _email = user.email ?? '';
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              key: ValueKey('name'),
              autofocus: true,
              initialValue: _name,
              onChanged: (val) {
                setState(() {
                  _name = val;
                  _errorText = null;
                });
              },
              keyboardType: TextInputType.text,
              maxLength: 16,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Colors.blue,
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter Name',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              key: ValueKey('mail'),
              initialValue: _email,
              onChanged: (email) {
                setState(() {
                  _email = email;
                  _errorText = null;
                });
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Colors.blue,
                labelText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter Email Address',
              ),
            ),
            SizedBox(height: 10),
            (_errorText == null)
                ? (_isLoading)
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor))
                    : ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () async {
                          if (_name == null || _name.isEmpty)
                            setState(() {
                              _errorText = 'Enter valid name';
                            });
                          else if (_email == null ||
                              _email.isEmpty ||
                              !mailRegex.hasMatch(_email))
                            setState(() {
                              _errorText = 'Enter valid email';
                            });
                          else {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              DataConnectionStatus connectionStatus =
                                  await ConnectivityService().checkStatus();
                              if (connectionStatus ==
                                  DataConnectionStatus.connected) {
                                await AuthService().addNameAndEmail(user, _name, _email);

                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pushReplacementNamed(
                                    CafeteriaSelectionScreen.routeName);
                              } else {
                                ConnectivityService().connectionNone();
                              }
                            } catch (err) {
                              // isError =  true;
                              if (err.code.toString() ==
                                  'ERROR_REQUIRES_RECENT_LOGIN') {
                                Navigator.of(context)
                                    .pushReplacementNamed(AuthScreen.routeName);
                              }
                              print(err.code.toString());
                              var msg =
                                  'Error Occured. Could not save name and email address.';
                              print(msg);
                              if (err.message != null) {
                                msg = err.message;
                              }
                              setState(() {
                                _isLoading = false;
                              });
                              await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 5000),
                                  content: Text(msg),
                                ),
                              );
                            }
                          }
                        })
                : Text(
                    _errorText,
                    style: GoogleFonts.oswald(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).errorColor),
                  ),
            TextButton(
                child: Text('Back to Login Screen',
                    style: TextStyle(color: Colors.black54)),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AuthScreen.routeName);
                })
          ],
        ),
      ),
    );
  }
}
