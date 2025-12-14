import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'schedule_page.dart';
import 'materials_page.dart';
import 'grades_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final String userId;
  final String userName;
  final String userNim;
  final String userRole;

  const MainNavigation({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userNim,
    required this.userRole,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(
        userId: widget.userId, 
        userName: widget.userName, 
        onQuickAccessTap: _onQuickAccessTap
      ),
      SchedulePage(userId: widget.userId),
      MaterialsPage(userId: widget.userId),
      GradesPage(userId: widget.userId),
      
      ProfilePage(
        userId: widget.userId, 
        userName: widget.userName, 
        userNim: widget.userNim
      ),
    ];
  }

  void _onQuickAccessTap(int index) {
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2C3E50),
        selectedItemColor: const Color(0xFF3498DB),
        unselectedItemColor: const Color(0xFFECF0F1).withOpacity(0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Nilai'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}