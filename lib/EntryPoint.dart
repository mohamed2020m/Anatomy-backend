import 'package:flutter/material.dart';
import 'package:my_app/screens/profil/Profil.dart';
import 'package:my_app/screens/saved/savedScreen.dart';

import 'screens/home/Home.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);
  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = [const Home(), SavedScreen(), Profil()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(appbar[_selectedIndex]),
        // ),
        body: SafeArea(
            child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        )),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconData(0xf1c2, fontFamily: 'MaterialIcons')),
              label: 'Saved',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.school),
            //   label: 'School',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 35, 133, 172),
          onTap: _onItemTapped,
        ));
  }
}
