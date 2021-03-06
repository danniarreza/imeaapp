import 'package:flutter/material.dart';
import 'package:imeaapp/screens/places/places_screen.dart';
import 'package:imeaapp/screens/prayertimes/prayertimes_screen.dart';

class Nav extends StatefulWidget {

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    PrayerTimesScreen(),
    PlacesScreen(),
    Text('Profile'),
  ];

  void _onItemTap(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imea App"),
      ),
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            title: Text("Prayers")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
              title: Text("Places")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              title: Text("FAQ")
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
