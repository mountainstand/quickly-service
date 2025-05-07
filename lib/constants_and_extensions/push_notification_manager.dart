import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'constants.dart';
import 'nonui_extensions.dart';
import 'shared_prefs.dart';

class PushNotificationsManager {
  PushNotificationsManager._sharedInstance() {
    _init();
  }
  static final PushNotificationsManager _shared =
      PushNotificationsManager._sharedInstance();
  factory PushNotificationsManager() => _shared;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final bool _initialized = false;

  final id = "12345678900000";

  Future<NotificationSettings> get getNotificationSettings async =>
      await _firebaseMessaging.getNotificationSettings();

  Future<NotificationSettings> get requestNotificationPermission async =>
      _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

  Future<void> _init() async {
    if (!_initialized) {
      // For iOS request permission first.

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      AndroidNotificationChannel channel = AndroidNotificationChannel(
        id, // id
        "Quickly VPN",
        description: "Quickly VPN Description",
        importance: Importance.high,
      );
      final notificationSettings = await requestNotificationPermission;
      ('Push Notification: ', notificationSettings.authorizationStatus).log();
      switch (notificationSettings.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          break;
        default:
          return;
      }

      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      // if (Platform.isIOS) {
      //   String? apnsToken = await _firebaseMessaging.getAPNSToken();
      //   ("APNs Token", apnsToken).log();
      //   if (apnsToken == null) {
      //     await Future<void>.delayed(
      //       const Duration(
      //         seconds: 5,
      //       ),
      //     );
      //     apnsToken = await _firebaseMessaging.getAPNSToken();
      //     ("APNs Token Second Times", apnsToken).log();
      //   }
      // }

      String? token = await _firebaseMessaging.getToken();
      "FCM Token: $token".log();
      final sharedPrefs = SharedPrefs();
      sharedPrefs.setString(
        value: (token ?? ""),
        inKey: SharedPrefsKeys.fcmToken,
      );

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        messageHandle(message);
        ('A new onMessageOpenedApp event was published!').log();
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          // _connectivity.message.sink.add(true);
          messageHandle(message);
        }
      });
    }
  }

  Future<dynamic> messageHandle(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final notification = message.notification;
    final title = notification?.title;
    final body = notification?.body;
    final data = message.data;
    ("data $data").log();
    // print("notification: " + notification.toString());
    // print(orderId);
    // print(trackingId);
    // print(pos);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1687497218170948721x8', 'Quick VPN Channel',
        channelDescription: 'Quick VPN Description.',
        icon: 'logo',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: BigTextStyleInformation(body ?? "",
            htmlFormatBigText: false,
            contentTitle: title,
            htmlFormatContentTitle: false,
            summaryText: '',
            htmlFormatSummaryText: true));
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    // flutterLocalNotificationsPlugin.initialize(
    //     InitializationSettings(android: initializationSettingsAndroid),
    //     onSelectNotification: handleLocalMessage);
    // flutterLocalNotificationsPlugin.show(
    //     1, title, body, platformChannelSpecifics,
    //     payload: orderId + "|" + pos);
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: initializationSettingsAndroid));
    flutterLocalNotificationsPlugin.show(
        1, title, body, platformChannelSpecifics);
  }

  Future? handleLocalMessage(String payload) {
    (payload).log();
    return null;
  }
}

/// NotificationGrantedExtension
extension NotificationGrantedExtension on AuthorizationStatus {
  bool get isGranted =>
      this == AuthorizationStatus.authorized ||
      this == AuthorizationStatus.provisional;
}
