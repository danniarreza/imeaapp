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
  DateTime _selectedDateTime = DateTime.now();

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
      child: prayerTimeRenderList.length > 0
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
      DateFormat('kk:mm').format(dateTimeRender),
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
      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
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
            Text(
              DateFormat('EEEE, dd MMMM y').format(_selectedDateTime),
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: _renderPrayerTimeCard(),
          ),
          Flexible(
            flex: 1,
            child: _renderDateSelectorCard(),
          ),
        ],
      ),
    );
  }
}
