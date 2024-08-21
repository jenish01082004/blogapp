import 'package:blog_app/screens/MyHomePage.dart';
import 'package:blog_app/screens/bloguplogpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(),
    BlogUploadPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'uplod blog',
          ),
        ],
      ),
    );
  }
}
