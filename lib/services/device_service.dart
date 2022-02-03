import 'package:flutter/material.dart';

class DeviceService {
  bool isTablet(BuildContext context) {
    // if (Platform.isIOS) {
    //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    //   return iosInfo.model.toLowerCase() == "ipad";
    // } else {
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    // Determine if we should use mobile layout or not, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    return shortestSide > 600;
    // }
  }
}
