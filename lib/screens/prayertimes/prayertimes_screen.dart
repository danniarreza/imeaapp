import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imeaapp/model/prayertime.dart';
import 'package:imeaapp/services/prayertime_database.dart';
import 'package:imeaapp/services/rest_api.dart';
import 'package:intl/intl.dart';
import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  List<PrayerTime> prayerTimeRenderList = [];
  DateTime _selectedDateTime = DateTime.now();
  bool prayerTimeRenderListReady = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iOSinitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSinitialize);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: notificationSelected);

    _readAllPrayerTime();
  }

  Future notificationSelected(String payload) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Notification Clicked ${payload}"),
          );
        });
  }

  _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "name", "This is my channel",
        importance: Importance.max, icon: 'ic_launcher');
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Task",
      "You created a Task",
      generalNotificationDetails,
      payload: "Task",
    );
  }

  _readAllPrayerTime() async {
    //get prayer times from rest api
    String url = "/prayertimes/get_all";
    List<PrayerTime> prayerTimeTempList = [];
    List<dynamic> responseJson = await getData(url);

    if (responseJson.length > 0) {
      //get prayer times from sqflite
      List<PrayerTime> listPrayerTime =
          await PrayerTimeDatabase.instance.readAll();
      List<DateTime> listPrayerDate =
          listPrayerTime.map((e) => e.date).toList();

      //evaluate which prayer time to insert or update

      Future.forEach(responseJson, (response) async {
        if (listPrayerDate.contains(DateTime.parse(response['date']))) {
          //if prayerdate existed in sqflite, then update

          PrayerTime updatePrayerTime = listPrayerTime.singleWhere((element) {
            return element.date == DateTime.parse(response['date']);
          });

          if (DateFormat('H:m:s').format(DateTime.parse(response['subuh'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.subuh)) {
            updatePrayerTime.subuh = DateTime.parse(response['subuh']);
            _setPrayerTimeNotificationTime(updatePrayerTime, "Subuh");
          }
          if (DateFormat('H:m:s').format(DateTime.parse(response['terbit'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.terbit)) {
            updatePrayerTime.terbit = DateTime.parse(response['terbit']);
          }
          if (DateFormat('H:m:s').format(DateTime.parse(response['dhuhur'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.dhuhur)) {
            updatePrayerTime.dhuhur = DateTime.parse(response['dhuhur']);
            _setPrayerTimeNotificationTime(updatePrayerTime, "Dhuhur");
          }
          if (DateFormat('H:m:s').format(DateTime.parse(response['ashar'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.ashar)) {
            updatePrayerTime.ashar = DateTime.parse(response['ashar']);
            _setPrayerTimeNotificationTime(updatePrayerTime, "Ashar");
          }
          if (DateFormat('H:m:s').format(DateTime.parse(response['maghrib'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.maghrib)) {
            updatePrayerTime.maghrib = DateTime.parse(response['maghrib']);
            _setPrayerTimeNotificationTime(updatePrayerTime, "Maghrib");
          }
          if (DateFormat('H:m:s').format(DateTime.parse(response['isha'])) !=
              DateFormat('H:m:s').format(updatePrayerTime.isha)) {
            updatePrayerTime.isha = DateTime.parse(response['isha']);
            _setPrayerTimeNotificationTime(updatePrayerTime, "Isha");
          }

          PrayerTimeDatabase.instance.update(updatePrayerTime);
          prayerTimeTempList.add(updatePrayerTime);
        } else {
          //otherwise insert new one
          PrayerTime newPrayerTime = PrayerTime(
            null,
            DateTime.parse(response['date']),
            DateTime.parse(response['subuh']),
            DateTime.parse(response['terbit']),
            DateTime.parse(response['dhuhur']),
            DateTime.parse(response['ashar']),
            DateTime.parse(response['maghrib']),
            DateTime.parse(response['isha']),
          );
          newPrayerTime =
              await PrayerTimeDatabase.instance.create(newPrayerTime);
          prayerTimeTempList.add(newPrayerTime);
          _setPrayerTimeNotificationDay(newPrayerTime);
        }
      }).then((value) {
        // setState for render and adzan notification
        setState(() {
          prayerTimeRenderList = [...prayerTimeTempList];
          prayerTimeRenderListReady = true;
          // _setPrayerTimeNotificationBulk(prayerTimeTempList);
        });
      });
    } else {
      //get prayer times from sqflite
      List<PrayerTime> listPrayerTime =
          await PrayerTimeDatabase.instance.readAll();

      setState(() {
        prayerTimeRenderList = [...listPrayerTime];
        prayerTimeRenderListReady = true;
        // _setPrayerTimeNotificationBulk(prayerTimeTempList);
      });
    }
  }

  _setPrayerTimeNotificationBulk(List<PrayerTime> prayerTimes) {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "name", "This is my channel",
        importance: Importance.max, icon: 'ic_launcher');
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    prayerTimes.forEach((prayerTime) {
      if (DateFormat('y-M-dd').format(prayerTime.date) ==
              DateFormat('y-M-dd').format(DateTime.now()) ||
          prayerTime.date.isAfter(DateTime.now())) {
        print(prayerTime.date.toIso8601String() +
            " is after " +
            DateTime.now().toIso8601String());

        if (prayerTime.subuh.isAfter(DateTime.now())) {
          _schedulePrayerTimeNotification(
              generalNotificationDetails, prayerTime, "Subuh");
        }
        if (prayerTime.dhuhur.isAfter(DateTime.now())) {
          _schedulePrayerTimeNotification(
              generalNotificationDetails, prayerTime, "Dhuhur");
        }
        if (prayerTime.ashar.isAfter(DateTime.now())) {
          _schedulePrayerTimeNotification(
              generalNotificationDetails, prayerTime, "Ashar");
        }
        if (prayerTime.maghrib.isAfter(DateTime.now())) {
          _schedulePrayerTimeNotification(
              generalNotificationDetails, prayerTime, "Maghrib");
        }
        if (prayerTime.isha.isAfter(DateTime.now())) {
          _schedulePrayerTimeNotification(
              generalNotificationDetails, prayerTime, "Isha");
        }
      }
    });
  }

  _setPrayerTimeNotificationDay(PrayerTime prayerTime) {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "name", "This is my channel",
        importance: Importance.max, icon: 'ic_launcher');
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    if (DateFormat('y-M-dd').format(prayerTime.date) ==
            DateFormat('y-M-dd').format(DateTime.now()) ||
        prayerTime.date.isAfter(DateTime.now())) {
      if (prayerTime.subuh.isAfter(DateTime.now())) {
        _schedulePrayerTimeNotification(
            generalNotificationDetails, prayerTime, "Subuh");
      }
      if (prayerTime.dhuhur.isAfter(DateTime.now())) {
        _schedulePrayerTimeNotification(
            generalNotificationDetails, prayerTime, "Dhuhur");
      }
      if (prayerTime.ashar.isAfter(DateTime.now())) {
        _schedulePrayerTimeNotification(
            generalNotificationDetails, prayerTime, "Ashar");
      }
      if (prayerTime.maghrib.isAfter(DateTime.now())) {
        _schedulePrayerTimeNotification(
            generalNotificationDetails, prayerTime, "Maghrib");
      }
      if (prayerTime.isha.isAfter(DateTime.now())) {
        _schedulePrayerTimeNotification(
            generalNotificationDetails, prayerTime, "Isha");
      }
    }
  }

  _setPrayerTimeNotificationTime(PrayerTime prayerTime, String prayerType) {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "name", "This is my channel",
        importance: Importance.max, icon: 'ic_launcher');
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    _schedulePrayerTimeNotification(
        generalNotificationDetails, prayerTime, prayerType);
  }

  _schedulePrayerTimeNotification(
      NotificationDetails generalNotificationDetails,
      PrayerTime prayerTime,
      String prayerType) {
    flutterLocalNotificationsPlugin.schedule(
        prayerTime.getPlusId(prayerType),
        prayerType,
        "Time for " +
            prayerType +
            " at " +
            DateFormat('H:mm').format(prayerTime.getPrayerHour(prayerType)),
        prayerTime.getPrayerHour(prayerType),
        generalNotificationDetails);
  }

  _renderPrayerTimeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: prayerTimeRenderListReady == true
          ? prayerTimeRenderList.length > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _renderPrayerTimeRow('Subuh'),
                    _renderDivider(),
                    _renderPrayerTimeRow('Terbit'),
                    _renderDivider(),
                    _renderPrayerTimeRow('Dhuhur'),
                    _renderDivider(),
                    _renderPrayerTimeRow('Ashar'),
                    _renderDivider(),
                    _renderPrayerTimeRow('Maghrib'),
                    _renderDivider(),
                    _renderPrayerTimeRow('Isha'),
                  ],
                )
              : Center(
                  child: Text(
                      "No Prayer Times found, please contact administrator."),
                )
          : SpinKitCircle(
              color: Colors.green,
            ),
    );
  }

  _renderPrayerTimeRow(String prayerType) {
    Text prayerTimeText;
    DateTime dateTimeRender;
    PrayerTime prayerTimeRender = prayerTimeRenderList.firstWhere((element) =>
        DateFormat('y-M-dd').format(element.date) ==
        DateFormat('y-M-dd').format(_selectedDateTime));

    if (prayerType.toLowerCase() == 'subuh') {
      dateTimeRender = prayerTimeRender.subuh;
    } else if (prayerType.toLowerCase() == 'terbit') {
      dateTimeRender = prayerTimeRender.terbit;
    } else if (prayerType.toLowerCase() == 'dhuhur') {
      dateTimeRender = prayerTimeRender.dhuhur;
    } else if (prayerType.toLowerCase() == 'ashar') {
      dateTimeRender = prayerTimeRender.ashar;
    } else if (prayerType.toLowerCase() == 'maghrib') {
      dateTimeRender = prayerTimeRender.maghrib;
    } else if (prayerType.toLowerCase() == 'isha') {
      dateTimeRender = prayerTimeRender.isha;
    }

    prayerTimeText = Text(
      DateFormat('H:mm').format(dateTimeRender),
      style: TextStyle(
        fontSize: 18,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              prayerType,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: prayerTimeText,
          ),
        ],
      ),
    );
  }

  _renderDateSelectorCard() {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: 35,
                onPressed: () {
                  setState(() {
                    _selectedDateTime = _selectedDateTime.add(
                      Duration(days: -1),
                    );
                  });
                }),
            // Text('Tuesday, 3 Agustus 2021'),
            FlatButton(
              onPressed: () async {
                // _showNotification();
                List<PendingNotificationRequest> p =
                    await flutterLocalNotificationsPlugin
                        .pendingNotificationRequests();
                p.forEach((element) {
                  print(element.body);
                });
              },
              child: Text(
                DateFormat('EEEE, dd MMMM y').format(_selectedDateTime),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 35,
              onPressed: () {
                setState(() {
                  _selectedDateTime = _selectedDateTime.add(
                    Duration(days: 1),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _renderDivider() {
    return Container(
      height: 2,
      child: Divider(
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width / 35),
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Prayer Time",
                          style: TextStyle(
                              // fontSize: 18
                            fontSize: MediaQuery.of(context).size.width / 20
                          ),
                        ),
                        // color: Colors.blue,
                      ),
                      Container(
                        child: Text(
                          HijriCalendar.fromDate(_selectedDateTime)
                              .toFormat("dd MMMM yyyy"),
                          style: TextStyle(
                              // fontSize: 14,
                              fontSize: MediaQuery.of(context).size.width / 25
                          ),
                        ),
                        // color: Colors.red,
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 12,
            child: _renderPrayerTimeCard(),
          ),
          Flexible(
            flex: 2,
            child: _renderDateSelectorCard(),
          ),
        ],
      ),
    );
  }
}
