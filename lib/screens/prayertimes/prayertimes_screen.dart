import 'package:flutter/material.dart';
import 'package:imeaapp/model/prayertime.dart';
import 'package:imeaapp/services/prayertime_database.dart';
import 'package:imeaapp/services/rest_api.dart';

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  List<PrayerTime> prayerTimeListFromDB = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _readAllPrayerTime();
  }

  _getPrayerTimes() async {
    String url = "/prayertimes/get_all";

    List<dynamic> responseJson = await getData(url);
    List<PrayerTime> newPrayerTimeList = [];

    responseJson.forEach((element) {
      PrayerTime newPrayerTime = PrayerTime(
        null,
        DateTime.parse(element['date']),
        DateTime.parse(element['subuh']),
        DateTime.parse(element['terbit']),
        DateTime.parse(element['dhuhur']),
        DateTime.parse(element['ashar']),
        DateTime.parse(element['maghrib']),
        DateTime.parse(element['isha']),
      );

      PrayerTimeDatabase.instance.create(newPrayerTime);
    });

    // responseJson.forEach((element) {
    //   newPrayerTimeList.add(PrayerTime(
    //       1,
    //       DateTime.parse(element['date']),
    //       DateTime.parse(element['subuh']),
    //       DateTime.parse(element['terbit']),
    //       DateTime.parse(element['dhuhur']),
    //       DateTime.parse(element['ashar']),
    //       DateTime.parse(element['maghrib']),
    //       DateTime.parse(element['isha'])));
    // });

    print(newPrayerTimeList[1].subuh);

    // setState(() {
    //   prayerTimeList = newPrayerTimeList;
    // });
  }

  _readAllPrayerTime() async {
    //get prayer times from rest api
    String url = "/prayertimes/get_all";
    List<dynamic> responseJson = await getData(url);

    //get prayer times from sqflite
    List<PrayerTime> listPrayerTime =
        await PrayerTimeDatabase.instance.readAll();
    List<DateTime> listPrayerDate = [];

    listPrayerTime.forEach((element) {
      listPrayerDate.add(element.date);
    });

    //evaluate which prayer time to insert or update
    responseJson.forEach((response) {
      if (listPrayerDate.contains(DateTime.parse(response['date']))) {
        //if prayerdate existed in sqflite, then update

        PrayerTime updatePrayerTime = listPrayerTime.singleWhere((element) {
          return element.date == DateTime.parse(response['date']);
        });

        updatePrayerTime.subuh = DateTime.parse(response['subuh']);
        updatePrayerTime.terbit = DateTime.parse(response['terbit']);
        updatePrayerTime.dhuhur = DateTime.parse(response['dhuhur']);
        updatePrayerTime.ashar = DateTime.parse(response['ashar']);
        updatePrayerTime.maghrib = DateTime.parse(response['maghrib']);
        updatePrayerTime.isha = DateTime.parse(response['isha']);

        PrayerTimeDatabase.instance.update(updatePrayerTime);
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

        PrayerTimeDatabase.instance.create(newPrayerTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () async {
              List<PrayerTime> listPrayerTime = await PrayerTimeDatabase.instance.readAll();
              print(listPrayerTime.first.subuh);
            },
            child: Text("Prayer Times"),
          ),
        ],
      ),
    );
  }
}
