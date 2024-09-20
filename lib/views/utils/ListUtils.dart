import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:photo_recovery/model/RateUs.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map> DrawerList = [
  {
    'ImageURL': "assets/images/GalleryIcon.png",
    'Name': "More Apps",
    'onTap': (BuildContext context) async {
      const String allAppLink =
          'https://play.google.com/store/apps/developer?id=AppVision+Studio&hl=en-US';
      _launchURL(context, allAppLink);
    },
  },
  {
    'ImageURL': "assets/images/PrivacyPolicyIcon.png",
    'Name': "Privacy Policy",
    'onTap': (BuildContext context) async {
      const String privacyPolicyLink =
          'https://customize.brainartit.com/DataRecovery/PrivacyPolicy.php';
      _launchURL(context, privacyPolicyLink);
    },
  },
  {
    'ImageURL': "assets/images/ShareIcon.png",
    'Name': "Share",
    'onTap': (BuildContext context) async {
      const String appLink =
          'https://play.google.com/store/apps/details?id=com.appvision.datarecovery';
      _launchURL(context, appLink);
    },
  },
  {
    'ImageURL': "assets/images/RateIcon.png",
    'Name': "Rate Us",
    'onTap': (BuildContext context) {
      RateUs().forceShowRateDialog(context);
    },
  },
];

Future<void> _launchURL(BuildContext context, String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      log(url);
      throw 'Could not launch $url';
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}
