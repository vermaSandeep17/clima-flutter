import 'package:flutter/material.dart';
import 'package:intern_task/screens/dashboard.dart';
import 'package:intern_task/screens/post.dart';
import 'package:intern_task/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> _pages = <Widget>[
    DashboardScreen(),
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: PageView(
        children: _pages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }
}
