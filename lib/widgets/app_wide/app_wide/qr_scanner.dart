import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/services/cafeteria_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScan extends StatefulWidget {
  final Cafeteria cafe;
  static const routeName = 'qr_scanner_screen';

  const QRScannerScan({Key key, this.cafe}) : super(key: key);

  @override
  _QRScannerScanState createState() => _QRScannerScanState();
}

class _QRScannerScanState extends State<QRScannerScan> {
  Barcode cafeId;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        cafeId = scanData;
      });
    }).onData((data) {
      // TODO Mai Arj need to check other apps like gpay and show some loading UI
      getCafe(data.code);
      controller.stopCamera();
    });
  }

  Future<void> getCafe(String id) async {
    try {
      Cafeteria cafe = await CafeteriasService().getCafeteriaByID(id);

      if (cafe != null) {
        final user = FirebaseAuth.instance.currentUser;

        await CafeteriasService()
            .selectCafe(user.uid, cafe, widget.cafe, context);
      } else
        print('No cafe exist with this scanned QR code ');
    } catch (err) {
      print('Error - QR Scanner - getCafe = ' + err.toString());
      await showAlert("No cafe exist with the scanned QR code");
    }
  }

  Future showAlert(String message) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return null;
        },
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  title: Text("Invalid Cafe Id"),
                  content: Text(message),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Back")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.resumeCamera();
                        },
                        child: Text("Scan Again"))
                  ],
                ),
              ));
        });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }
}
