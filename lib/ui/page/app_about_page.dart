import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myclock/common/constant/app_colors.dart';
import 'package:myclock/common/utils/device_utils.dart';
import 'package:myclock/config/app_config.dart';
import 'package:myclock/common/channel/native_method_channel.dart';
import 'package:myclock/generated/l10n.dart';

class AppAbout extends StatefulWidget {
  @override
  _AppAboutState createState() => _AppAboutState();
}

class _AppAboutState extends State<AppAbout> {
  String version = '';

  @override
  void initState() {
    super.initState();

    NativeChannel.appVersion().then((value) {
      print(value);
      if (value is String) {
        setState(() {
          version = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).tips_app_about),
        brightness: Brightness.dark,
        backgroundColor: AppColors.ME_SUB_COLOR,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
              width: DeviceUtils.scale_width(context, 0.25, 0.3, 0.4),
              child: Image.asset("assets/images/app_logo.png",
                  fit: BoxFit.contain),
            ),
            Text(
              "${AppConfig.AppName}",
              style: TextStyle(
                  fontSize: DeviceUtils.get_size(context, 20, 23, 25),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "v ${version}",
              style: TextStyle(
                color: AppColors.isDarkMode(context) ? Colors.white24 : Colors.black54,
                fontSize: DeviceUtils.get_size(context, 14, 15, 18),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).tips_app_desc,
                  style: TextStyle(color: AppColors.isDarkMode(context) ? Colors.white38 : Colors.black54),
                ),
              ],
            )),
            Text(
              'Copyright ?? 2021 iHTCboy',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
