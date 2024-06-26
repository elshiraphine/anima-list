import 'package:AnimaList/screens/auth/home_screen.dart';
import 'package:AnimaList/screens/watchlist/watchlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:AnimaList/screens/community_screen.dart';
import 'package:AnimaList/screens/discover_screen.dart';

class HomeScreenWrapper extends StatelessWidget {
  final Function refresh;

  const HomeScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const HomeScreen(),
    );
  }
}

class CommunityScreenWrapper extends StatelessWidget {
  final Function refresh;

  const CommunityScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: CommunityScreen(),
    );
  }
}

class WatchlistScreenWrapper extends StatelessWidget {
  final Function refresh;

  const WatchlistScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const WatchlistScreen(),
    );
  }
}

class DiscoverScreenWrapper extends StatelessWidget {
  final Function refresh;

  const DiscoverScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const DiscoverScreen(),
    );
  }
}
