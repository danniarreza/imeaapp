import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imeaapp/model/prayertime.dart';
import 'package:imeaapp/services/prayertime_database.dart';
import 'package:imeaapp/services/rest_api.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  List<PrayerTime> prayerTimeRenderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _readAllPrayerTime();
  }

  _readAllPrayerTime() async {
    //get prayer times from rest api
    String url = "/prayertimes/get_all";
    List<PrayerTime> prayerTimeTempList = [];
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
        PrayerTimeDatabase.instance.create(newPrayerTime);
        prayerTimeTempList.add(newPrayerTime);
      }
    });

    // setState for render
    setState(() {
      prayerTimeRenderList = [...prayerTimeTempList];
    });
  }

  _renderPrayerTimeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
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
      ),
    );
  }

  _renderPrayerTimeRow(String prayerType) {
    Text prayerTypeText;
    DateTime prayerTime;

    if (prayerType.toLowerCase() == 'subuh') {
      prayerTime = prayerTimeRenderList.first.subuh;
    } else if (prayerType.toLowerCase() == 'terbit') {
      prayerTime = prayerTimeRenderList.first.terbit;
    } else if (prayerType.toLowerCase() == 'dhuhur') {
      prayerTime = prayerTimeRenderList.first.dhuhur;
    } else if (prayerType.toLowerCase() == 'ashar') {
      prayerTime = prayerTimeRenderList.first.ashar;
    } else if (prayerType.toLowerCase() == 'maghrib') {
      prayerTime = prayerTimeRenderList.first.maghrib;
    } else if (prayerType.toLowerCase() == 'isha') {
      prayerTime = prayerTimeRenderList.first.isha;
    }

    prayerTypeText = Text(DateFormat('kk:mm').format(prayerTime));

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              prayerType,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: prayerTypeText,
          ),
        ],
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RaisedButton(
          //   onPressed: () async {
          //     // List<PrayerTime> listPrayerTime = await PrayerTimeDatabase.instance.readAll();
          //     print(prayerTimeRenderList.first.subuh);
          //   },
          //   child: Text("Prayer Times"),
          // ),

          prayerTimeRenderList.length > 0
              ? _renderPrayerTimeCard()
              : SpinKitCircle(
                  color: Colors.green,
                ),
        ],
      ),
    );
  }
}
