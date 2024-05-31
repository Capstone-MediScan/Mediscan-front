import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediscan/theme/colors.dart';
//import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show Platform;
import 'package:mediscan/alertsetting.dart'; // 필요한 다른 파일 import

class MediScanHome extends StatefulWidget {
  const MediScanHome({super.key});

  @override
  MediScanHomeState createState() => MediScanHomeState();
}

class MediScanHomeState extends State<MediScanHome> {
  List<String> alertInfos = []; // 알림 정보를 저장할 리스트
  List<bool> alertStatuses = []; // 각 알림의 토글 상태를 저장할 리스트

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher'); // const 추가
    var initializationSettingsIOS =
        const IOSInitializationSettings(); // const 추가
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 권한 요청
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> _scheduleNotification(
      int id, TimeOfDay time, String period) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final now = DateTime.now();
    int hour = period == 'PM' && time.hour != 12 ? time.hour + 12 : time.hour;
    hour = period == 'AM' && time.hour == 12 ? 0 : hour;
    var notificationTime =
        DateTime(now.year, now.month, now.day, hour, time.minute);

    if (notificationTime.isBefore(now)) {
      notificationTime = notificationTime
          .add(const Duration(days: 1)); // 알림 시간이 이미 지났다면 다음 날로 예약
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '약 시간',
      '약 먹을 시간이에요',
      tz.TZDateTime.from(notificationTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AlertSetting(
                    initialTime:
                        const TimeOfDay(hour: 12, minute: 0), // const 추가
                    daysStatus: List.filled(7, false), // 예시로 모든 요일을 false로 초기화
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                  opaque: false,
                  barrierColor: Colors.transparent,
                ),
              );
              if (result != null && result['action'] == 'save') {
                setState(() {
                  alertInfos.add(result['time']);
                  alertStatuses.add(true); // 초기 상태를 true로 설정
                  final timeParts = result['time'].split(' ');
                  final timeOfDayParts = timeParts[0].split(':');
                  final period = timeParts[1];
                  final timeOfDay = TimeOfDay(
                    hour: int.parse(timeOfDayParts[0]),
                    minute: int.parse(timeOfDayParts[1]),
                  );
                  _scheduleNotification(
                      alertInfos.length - 1, timeOfDay, period); // 새로운 알림 예약
                });
              }
            },
            child: const Text('알림 추가',
                style: TextStyle(color: Colors.green)), // const 추가
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: alertInfos.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              child: ListTile(
                title: Text(alertInfos[index]),
                leading:
                    const Icon(Icons.alarm, color: Colors.grey), // const 추가
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.blue), // const 추가
                      onPressed: () async {
                        final timeParts = alertInfos[index].split(' ');
                        final timeOfDayParts = timeParts[0].split(':');
                        //final period = timeParts[1];
                        final timeOfDay = TimeOfDay(
                          hour: int.parse(timeOfDayParts[0]),
                          minute: int.parse(timeOfDayParts[1]),
                        );
                        final result = await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    AlertSetting(
                              initialTime: timeOfDay,
                              daysStatus: List.filled(7, false),
                              alertIndex: index,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child;
                            },
                            opaque: false,
                            barrierColor: Colors.transparent,
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            if (result['action'] == 'save') {
                              alertInfos[index] = result['time'];
                              if (alertStatuses[index]) {
                                final timeParts = result['time'].split(' ');
                                final timeOfDayParts = timeParts[0].split(':');
                                final period = timeParts[1];
                                final timeOfDay = TimeOfDay(
                                  hour: int.parse(timeOfDayParts[0]),
                                  minute: int.parse(timeOfDayParts[1]),
                                );
                                _scheduleNotification(
                                    index, timeOfDay, period); // 알림 재설정
                              }
                            } else if (result['action'] == 'delete') {
                              alertInfos.removeAt(index);
                              alertStatuses.removeAt(index);
                              flutterLocalNotificationsPlugin
                                  .cancel(index); // 알림 취소
                            }
                          });
                        }
                      },
                    ),
                    Switch(
                      value: alertStatuses[index],
                      onChanged: (bool value) {
                        setState(() {
                          alertStatuses[index] = value;
                          if (value) {
                            final timeParts = alertInfos[index].split(' ');
                            final timeOfDayParts = timeParts[0].split(':');
                            final period = timeParts[1];
                            final timeOfDay = TimeOfDay(
                              hour: int.parse(timeOfDayParts[0]),
                              minute: int.parse(timeOfDayParts[1]),
                            );
                            _scheduleNotification(index, timeOfDay, period);
                          } else {
                            flutterLocalNotificationsPlugin.cancel(index);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(), // const 추가
        ),
      ),
    );
  }
}
