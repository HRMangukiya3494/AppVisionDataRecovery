import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class RateUs {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 0,
    remindDays: 1,
    remindLaunches: 1,
    googlePlayIdentifier: 'com.appvision.datarecovery',
  );

  Future<void> initializeRateMyApp(BuildContext context) async {
    try {
      await rateMyApp.init();
      log('RateMyApp initialized');

      if (rateMyApp.shouldOpenDialog) {
        showRateDialog(context);
      } else {
        log("Dialog conditions not met. Not Open...");
      }
    } catch (error) {
      log("Error initializing RateMyApp: $error");
    }
  }

  void showRateDialog(BuildContext context) {
    rateMyApp.showRateDialog(
      context,
      title: 'Rate this app',
      message:
      'If you like this app, please take a little bit of your time to review it!',
      rateButton: 'RATE',
      noButton: 'NO THANKS',
      laterButton: 'MAYBE LATER',
      listener: (button) {
        switch (button) {
          case RateMyAppDialogButton.rate:
            log('Clicked on "Rate".');
            launchURL();
            break;
          case RateMyAppDialogButton.later:
            log('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            log('Clicked on "No".');
            break;
        }
        return true;
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(),
      onDismissed: () =>
          rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  }

  void launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.appvision.datarecovery';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      log('Could not launch $url');
    }
  }

  void forceShowRateDialog(BuildContext context) {
    rateMyApp.showStarRateDialog(
      context,
      title: 'Enjoying This App?',
      message: 'Tap a star to rate it on the play store.',
      actionsBuilder: (context, stars) {
        return [
          ElevatedButton(
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              log('Thanks for the ${stars == null ? '0' : stars.round().toString()} star(s) !');
              if (stars != 0) {
                launchURL();
              }
              Navigator.pop(context);
            },
          ),
        ];
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: const StarRatingOptions(),
      onDismissed: () async {
        await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
      },
    );
  }
}