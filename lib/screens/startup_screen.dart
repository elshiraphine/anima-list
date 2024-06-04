import 'package:anima_list/screens/community_screen.dart';
import 'package:anima_list/screens/home_screen.dart';
import 'package:anima_list/screens/profile_screen.dart';
import 'package:anima_list/screens/watchlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../services/navigation_wrapper.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final PersistentTabController _controller = PersistentTabController();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.red.shade900,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white38,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreenWrapper(refresh: refreshScreen, key: UniqueKey()),
      CommunityScreenWrapper(refresh: refreshScreen, key: UniqueKey()),
      WatchlistScreenWrapper(refresh: refreshScreen, key: UniqueKey()),
      ProfileScreenWrapper(refresh: refreshScreen, key: UniqueKey()),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade300,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.forum),
        title: ("Community"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade300,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.library_books),
        title: ("Watchlist"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade300,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: ("Profile"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade300,
      ),
    ];
  }

  void refreshScreen() {
    setState(() {});
  }
}