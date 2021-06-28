import 'package:flutter/material.dart';
import 'package:myclock/common/constant/app_colors.dart';
import 'package:myclock/common/utils/config_storage.dart';
import 'package:myclock/common/utils/device_utils.dart';
import 'package:myclock/generated/l10n.dart';

class LanguageSettings extends StatefulWidget {
  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String groupValue = 'zh';

  @override
  void initState() {
    super.initState();
    _init_storage();
  }

  void _init_storage() {
    AppStorage.getString(AppStorage.K_STRING_LANGUAGE_SETTINGS).then((value) {
      setState(() {
        groupValue = value ?? 'zh';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).set_localizetion),
        brightness: Brightness.dark,
        backgroundColor: AppColors.ME_MAIN_COLOR,
      ),
      body: ListView(
        children: [
          RadioListTile<String>(
            title: Text('中文'),
            value: 'zh',
            groupValue: groupValue,
            onChanged: _changed,
          ),
          Divider(height: 1),
          RadioListTile<String>(
              title: Text('English'),
              value: 'en',
              groupValue: groupValue,
              onChanged: _changed),
        ],
      ),
    );
  }

  void _changed(value) {
    if (value != null) {
      AppStorage.setString(AppStorage.K_STRING_LANGUAGE_SETTINGS, value);
      setState(() {
        groupValue = value;
        if (value == "zh") S.load(Locale('zh', ''));
        if (value == "en") S.load(Locale('en', 'US'));
      });
    }
  }
}
