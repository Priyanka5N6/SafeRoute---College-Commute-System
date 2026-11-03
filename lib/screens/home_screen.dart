import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'track_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  void _toast(BuildContext c, String msg) {
    ScaffoldMessenger.of(c).hideCurrentSnackBar();
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning,', style: TextStyle(color: Colors.black54)),
                    Text('Priya Sharma',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: kPrimary,
                    child: Text('PS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: kAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Safety status card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [kAccent, Color(0xFF26A69A)]),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: Colors.white, size: 44),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("You're all set", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('2 trusted contacts will be alerted in an emergency.',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          const Text('Quick actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: [
              _Action(Icons.directions_bus, 'Track Bus', kPrimary, () => onNavigate(1)),
              _Action(Icons.people, 'Carpool', kAccent, () => onNavigate(2)),
              _Action(Icons.share_location, 'Share Trip', Colors.orange, () => _toast(context, 'Live trip link sent to trusted contacts')),
              _Action(Icons.directions_walk, 'Safe Walk', Colors.purple, () => _toast(context, 'Safe Walk buddy requested')),
            ],
          ),
          const SizedBox(height: 22),

          const Text("Today's buses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (final r in routes) _RouteCard(route: r),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardBox(color: const Color(0xFFFFF8E1)),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Safety tip: Share your live trip with a friend when travelling after 7 PM.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Action(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final BusRoute route;
  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: cardBox(),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TrackScreen(route: route))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kPrimary.withAlpha(25), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.directions_bus, color: kPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('${route.seatsFree} seats free  |  ${route.plate}',
                        style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${route.etaMin}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kAccent)),
                  const Text('min', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
