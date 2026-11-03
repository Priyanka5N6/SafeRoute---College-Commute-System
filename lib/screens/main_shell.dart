import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'carpool_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'sos_screen.dart';
import 'track_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onNavigate: (i) => setState(() => _index = i)),
          TrackScreen(route: routes[0]),
          const CarpoolScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDanger,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SosScreen())),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus), label: 'Track'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Carpool'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
