import 'package:flutter/material.dart';
import 'package:nit_scholar/pages/more_page.dart';
import 'package:nit_scholar/pages/pay_card_page.dart';
import 'package:nit_scholar/providers/app_provider.dart';
import 'package:nit_scholar/utils/color_util.dart';
import 'package:provider/provider.dart';
import 'schedule_page.dart';
import 'grades_page.dart';
import 'my_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SchedulePage(),
    PayCardPage(),
    MorePage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 辅助函数：构建带有动画效果的图标
  Widget _buildAnimatedIcon(IconData icon, int index, {bool isActive = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: isActive ? 1.2 : 1.0),
      duration: Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Icon(icon,
              color: isActive ? MinColor.fromHex("#5883F2") : Colors.grey),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 59, 172, 229).withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: MinColor.fromHex("#F1F1F1"),
          selectedItemColor: MinColor.fromHex("#5883F2"),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.calendar_today_outlined, 0),
              activeIcon:
                  _buildAnimatedIcon(Icons.calendar_today, 0, isActive: true),
              label: '课程表',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.account_balance_wallet_outlined,
                  1), // Use account_balance_wallet_outlined
              activeIcon: _buildAnimatedIcon(Icons.account_balance_wallet, 1,
                  isActive: true), // Use account_balance_wallet
              label: '校园卡',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.add_box_outlined, 2),
              activeIcon: _buildAnimatedIcon(Icons.add_box, 2, isActive: true),
              label: '更多',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.person_outline, 3),
              activeIcon: _buildAnimatedIcon(Icons.person, 3, isActive: true),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}
