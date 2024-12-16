import 'package:TerraViva/screens/favorite/Favorite.dart';
import 'package:TerraViva/screens/quizzes/QuizScreen.dart';
import 'package:TerraViva/screens/search/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/screens/saved/savedScreen.dart';

import 'screens/home/Home.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);
  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;

  // Create a controller for the PageView
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  final screens = [
    const Home(),
    const QuizScreen(),
    const Favorite(),
    const SavedNotesScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: screens,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Notes',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6D83F2),
        onTap: _onItemTapped,
      ),
    );
  }
}
