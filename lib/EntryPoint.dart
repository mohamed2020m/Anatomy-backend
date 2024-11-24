import 'package:TerraViva/screens/favorite/Favorite.dart';
import 'package:TerraViva/screens/quizzes/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/screens/profil/Profil.dart';
import 'package:TerraViva/screens/saved/savedScreen.dart';

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


  final screens = [const Home(), const SavedScreen(), const QuizScreen(), const Favorite()];

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
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quizzes',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person_outline),
            //   label: 'Profile',
            // ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 35, 133, 172),
          onTap: _onItemTapped,
        ));
  }
}
