import 'package:flutter/material.dart';
import 'package:imeaapp/screens/prayertimes/prayertimes_screen.dart';

class Nav extends StatefulWidget {

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    PrayerTimesScreen(),
    Text('Messages'),
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            title: Text("Prayers")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.nightlight_round),
              title: Text("Mosques")
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
