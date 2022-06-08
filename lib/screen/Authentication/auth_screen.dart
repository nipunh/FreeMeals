import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/screen_name.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/ErrorScreen/error_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/name_screen.dart';
import 'package:freemeals/services/auth_service.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/notification_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/countdown_flutter/countdown_flutter.dart';
import 'package:freemeals/widgets/dialog_boxes/policy_dialog.dart';
import 'package:international_phone_input/international_phone_input.dart';
// import 'package:platos_client_app/enums/connectivity_status.dart';
// import 'package:platos_client_app/enums/screen_name.dart';
// import 'package:platos_client_app/screens/cafeteria_selection_screen.dart';
// import 'package:platos_client_app/screens/error_screen.dart';
// import 'package:platos_client_app/screens/name_screen.dart';
// import 'package:platos_client_app/services/auth_service.dart';
// import 'package:platos_client_app/services/connectivity_service.dart';
// import 'package:platos_client_app/services/notification_service.dart';
// import 'package:platos_client_app/widgets/app_wide/error_connection_page.dart';
// import 'package:platos_client_app/widgets/countdown_flutter/countdown_flutter.dart';
// import 'package:platos_client_app/widgets/dialog_boxes/policy_dialog.dart';
import 'package:provider/provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      initialData: ConnectivityStatus.Connected,
      create: (ctx) => ConnectivityService().connectionStatusController.stream,
      child: Consumer<ConnectivityStatus>(
        builder: (ctx, connectionStatus, ch) =>
            (connectionStatus == ConnectivityStatus.None)
                ? ErrorConnectionPage(routeName: AuthScreen.routeName)
                : SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: _AuthScreenWidget(),
                    ),
                  ),
      ),
    );
  }
}

class _AuthScreenWidget extends StatefulWidget {
  const _AuthScreenWidget({Key key}) : super(key: key);

  @override
  __AuthScreenWidgetState createState() => __AuthScreenWidgetState();
}

class __AuthScreenWidgetState extends State<_AuthScreenWidget> {
  final formKey = GlobalKey<FormState>();

  String verificationId = '';
  String smsCode = '';
  int resendToken = 0;
  String phoneNo = '';
  String phoneNumber = '';
  String phoneIsoCode = 'CA';
  bool countDone = false;
  bool codeSent = false;
  bool _loading = false;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Image.asset('assets/images/auth_screen.png'),
            ),
          ),
          (!codeSent)
              ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Container(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InternationalPhoneInput(
                        errorStyle: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline1.fontSize,
                            fontWeight: FontWeight.normal),
                        showCountryFlags: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                        ),
                        onPhoneNumberChange: onPhoneNumberChange,
                        initialPhoneNumber: phoneNumber,
                        initialSelection: phoneIsoCode,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  codeSent = false;
                                  countDone = false;
                                  _loading = false;
                                  smsCode = '';
                                });
                              }),
                          Text(
                            'Phone : ' + phoneNo,
                          )
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: 'Enter OTP'),
                        autofocus: true,
                        onChanged: (val) {
                          setState(() {
                            smsCode = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 10),
          ((phoneNo != '' && !codeSent) || (codeSent && smsCode.length == 6))
              ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: (_loading)
                      ? Container(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            if (phoneNo != '' && !codeSent)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: CheckboxListTile(
                                  activeColor: Color(0xFFFFCB37),
                                  value: agreed,
                                  onChanged: (value) {
                                    setState(() {
                                      agreed = value;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "I have read and accept\n",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Terms & Conditions ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .fontSize,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PolicyDialog(
                                                    mdFileName:
                                                        'terms_and_conditions.md',
                                                  );
                                                },
                                              );
                                            },
                                        ),
                                        TextSpan(
                                          text: "and ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .fontSize,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Privacy Policy.",
                                          style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .fontSize,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PolicyDialog(
                                                    mdFileName:
                                                        'privacy_policy.md',
                                                  );
                                                },
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Center(
                                    child: codeSent
                                        ? Text('Login')
                                        : Text('Verify')),
                                onPressed: () async {
                                  if (!agreed) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                          'Please accept Terms and Conditions and Privacy Policy to proceed',
                                        ),
                                      ),
                                    );
                                  } else {
                                    try {
                                      setState(() {
                                        _loading = true;
                                      });

                                      DataConnectionStatus connectionStatus =
                                          await ConnectivityService()
                                              .checkStatus();
                                      if (connectionStatus ==
                                          DataConnectionStatus.connected) {
                                        if (codeSent) {
                                          final screen = await AuthService().signInWithOTP(smsCode,verificationId, phoneNo);
                                          FocusScope.of(context).unfocus();
                                          if (screen == null) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    ErrorScreen.routeName,
                                                    arguments:
                                                        AuthScreen.routeName);
                                          }
                                          if (screen == ScreenName.Name) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    NameScreen.routeName);
                                          }
                                          if (screen == ScreenName.Discovery) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    DiscoverPage.routeName);
                                          }
                                        } else {
                                          setState(() {
                                            codeSent = true;
                                            countDone = false;
                                            _loading = false;
                                          });
                                          await verifyPhone(phoneNo, context);
                                        }
                                      } else {
                                        ConnectivityService().connectionNone();
                                      }
                                    } catch (err) {
                                      var msg =
                                          'Error Occured. Could not Sign in';
                                      if (err.message != null) {
                                        msg = err.message;
                                      }
                                      print('Error - Auth Screen - sign in = ' +
                                          err.toString());
                                      setState(() {
                                        _loading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              Duration(milliseconds: 5000),
                                          content: Text(msg),
                                        ),
                                      );
                                    }
                                  }
                                }),
                          ],
                        ),
                )
              : SizedBox(height: 30),
          if (phoneNo != '' && codeSent && !countDone)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Countdown(
                  duration: Duration(seconds: 35),
                  onFinish: () {
                    setState(() {
                      countDone = true;
                    });
                  },
                  builder: (BuildContext ctx, Duration remaining) {
                    return Text('Resend SMS in ${remaining.inSeconds}');
                  },
                ),
              ),
            ),
          if (phoneNo != '' && codeSent && countDone)
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextButton(
                  child: Center(child: Text('Resend OTP')),
                  onPressed: () async {
                    try {
                      DataConnectionStatus connectionStatus =
                          await ConnectivityService().checkStatus();
                      if (connectionStatus == DataConnectionStatus.connected) {
                        await verifyPhone(phoneNo, context);
                        setState(() {
                          countDone = false;
                        });
                      } else {
                        ConnectivityService().connectionNone();
                      }
                    } catch (exception, stackTrace) {
                      // await Sentry.captureException(
                      //   exception,
                      //   stackTrace: stackTrace,
                      // );

                      Navigator.of(context).pushReplacementNamed(
                          ErrorScreen.routeName,
                          arguments: AuthScreen.routeName);
                    }
                  }),
            ),
        ],
      ),
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNo = internationalizedPhoneNumber;
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  Future<void> verifyPhone(phoneNo, context) async {
    final _auth = FirebaseAuth.instance;

    final PhoneVerificationCompleted verified =
        (AuthCredential credential) async {
      final screen = await AuthService().signIn(credential, phoneNo);
      final newUser = FirebaseAuth.instance.currentUser;
      await NotificationService().loginSubscribe(newUser.uid);
      if (Platform.isAndroid) {
        await NotificationService().createOrderChannel();
      }
      if (screen == null) {
        Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName,
            arguments: AuthScreen.routeName);
      }
      if (screen == ScreenName.Name) {
        Navigator.of(context).pushReplacementNamed(NameScreen.routeName);
      }
      if (screen == ScreenName.Discovery) {
        Navigator.of(context)
            .pushReplacementNamed(DiscoverPage.routeName);
      }
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print(
          'Error - Auth screen - verify phone failed ' + authException.message);
      var msg = 'Error Occured. Could not Sign in';
      if (authException.message != null) {
        msg = authException.message;
      }
      print(msg);
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 5000),
          content: Text(msg),
        ),
      );
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      setState(() {
        verificationId = verId;
        resendToken = forceResend;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      setState(() {
        if (mounted) {
          verificationId = verId;
        }
      });
    };

    try {
      if (this.resendToken == 0) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout,
        );
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout,
          forceResendingToken: this.resendToken,
        );
      }
    } catch (err) {
      print('error Auth Screen - verify fucntion = ' + err.toString());
      throw Exception(err);
    }
  }
}
