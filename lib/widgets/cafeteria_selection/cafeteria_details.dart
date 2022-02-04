import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/ErrorScreen/connection_error_screen.dart';
import 'package:freemeals/screen/ErrorScreen/error_screen.dart';
import 'package:freemeals/services/cafeteria_service.dart';
import 'package:freemeals/services/connectivity_service.dart';
// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/screens/cafeteria_selection_screen.dart';
// import 'package:platos_client_app/screens/error_connection_screen.dart';
// import 'package:platos_client_app/screens/error_screen.dart';
// import 'package:platos_client_app/services/cafeteria_service.dart';
// import 'package:platos_client_app/services/connectivity_service.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

class CafeteriaDetails extends StatefulWidget {
  final Cafeteria cafe;
  final Cafeteria oldCafe;

  const CafeteriaDetails({Key key, @required this.cafe, @required this.oldCafe})
      : super(key: key);

  @override
  _CafeteriaDetailsState createState() => _CafeteriaDetailsState();
}

class _CafeteriaDetailsState extends State<CafeteriaDetails> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: InkWell(
          child: Container(
            decoration:
                (widget.oldCafe != null && widget.cafe.id == widget.oldCafe.id)
                    ? BoxDecoration(
                        // color: Theme.of(context).colorScheme.secondary,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    : BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                enabled: widget.cafe.isOpen,
                dense: false,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                title: Text(
                  widget.cafe.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.cafe.name),
                    Text(widget.cafe.city),
                  ],
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: (widget.cafe.banners== null ||
                          widget.cafe.banners.isEmpty)
                      ? Image.asset(
                          'assets/images/platos-original-png-circle.png',
                        )
                      : Image.network(
                          widget.cafe.banners[0],
                          fit: BoxFit.fill,
                        ),
                ),
                trailing: (_loading)
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )
                    : (!widget.cafe.isOpen)
                        ? Text('Closed',
                            style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontWeight: FontWeight.w600))
                        : Text('Open',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          onTap: () async {
            try {
              if (widget.cafe.cafeCode == 0 ||
                  (widget.oldCafe != null &&
                      widget.cafe.id == widget.oldCafe.id)) {
                setState(() {
                  _loading = true;
                });
                final connectionStatus =
                    await DataConnectionChecker().connectionStatus;
                if (connectionStatus == DataConnectionStatus.connected) {
                  await CafeteriasService().selectCafe(
                      user.uid, widget.cafe, widget.oldCafe, context);
                } else {
                  ConnectivityService().connectionNone();
                }
              } else {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 250),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {
                      return null;
                    },
                    transitionBuilder: (context, a1, a2, widget1) {
                      return Transform.scale(
                          scale: a1.value,
                          child: Opacity(
                            opacity: a1.value,
                            child: _CafeCodeDialog(
                              cafe: widget.cafe,
                              user: user,
                            ),
                          ));
                    });
              }
            } catch (exception, stackTrace) {
              // await Sentry.captureException(
              //   exception,
              //   stackTrace: stackTrace,
              // );

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName,
                  arguments: CafeteriaSelectionScreen.routeName);
            }
          }),
    );
  }
}

class _CafeCodeDialog extends StatefulWidget {
  final Cafeteria oldCafe;
  final User user;
  final Cafeteria cafe;
  final bool selectedCafe;
  const _CafeCodeDialog(
      {Key key, this.user, this.cafe, this.selectedCafe, this.oldCafe})
      : super(key: key);

  @override
  __CafeCodeDialogState createState() => __CafeCodeDialogState();
}

class __CafeCodeDialogState extends State<_CafeCodeDialog> {
  TextEditingController _codeController;
  bool correctCode = true;
  String _errorText = null;
  bool _loading = false;
  FocusNode _focusNode;
  @override
  void initState() {
    _codeController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text('Enter Cafeteria Code')),
      content: ListTile(
        title: TextField(
          maxLines: 1,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).primaryColor,
          controller: _codeController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _validate,
          maxLength: 4,
          decoration: InputDecoration(
              errorText: _errorText,
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Cafeteria Code'),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Back' , style: TextStyle(color:Colors.black)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        (_loading)
            ? TextButton(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                onPressed: null,
              )
            : TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
                child: const Text('Enter',style: TextStyle(color:Colors.black)),
                onPressed: () async {
                  if (int.parse(_codeController.text) == widget.cafe.cafeCode) {
                    try {
                      setState(() {
                        _loading = true;
                      });
                      final connectionStatus =
                          await DataConnectionChecker().connectionStatus;
                      if (connectionStatus == DataConnectionStatus.connected) {
                        _focusNode.unfocus();
                        await CafeteriasService().selectCafe(widget.user.uid,
                            widget.cafe, widget.oldCafe, context);
                      } else {
                        Navigator.of(context).pushReplacementNamed(
                            ConnectionErrorScreen.routeName,
                            arguments: CafeteriaSelectionScreen.routeName);
                      }
                    } catch (exception, stackTrace) {
                      // await Sentry.captureException(
                      //   exception,
                      //   stackTrace: stackTrace,
                      // );

                      Navigator.of(context).pushReplacementNamed(
                          ErrorScreen.routeName,
                          arguments: CafeteriaSelectionScreen.routeName);
                    }
                  } else {
                    setState(() {
                      _errorText = 'Invalid Cafe Code';
                    });
                  }
                }),
      ],
    );
  }

  void _validate(String stringCafeCode) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }
}
