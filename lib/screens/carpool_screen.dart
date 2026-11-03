import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class CarpoolScreen extends StatefulWidget {
  const CarpoolScreen({super.key});
  @override
  State<CarpoolScreen> createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  String _filter = 'All';

  List<Ride> get _visible {
    switch (_filter) {
      case 'Women only':
        return rides.where((r) => r.womenOnly).toList();
      case 'Leaving soon':
        return rides.where((r) => r.soon).toList();
      default:
        return rides;
    }
  }

  void _offerRide() {
    final from = TextEditingController();
    final time = TextEditingController(text: '8:30 AM');
    int seats = 2;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Offer a ride', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: from,
                decoration: const InputDecoration(labelText: 'Starting from', prefixIcon: Icon(Icons.my_location)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: time,
                decoration: const InputDecoration(labelText: 'Departure time', prefixIcon: Icon(Icons.schedule)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event_seat, color: Colors.black54),
                  const SizedBox(width: 10),
                  const Text('Seats available'),
                  const Spacer(),
                  IconButton(
                    onPressed: seats > 1 ? () => setSheet(() => seats--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$seats', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: seats < 5 ? () => setSheet(() => seats++) : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (from.text.trim().isEmpty) return;
                  setState(() => rides.insert(
                      0,
                      Ride(
                          name: 'You',
                          from: from.text.trim(),
                          time: time.text.trim(),
                          seats: seats,
                          rating: 5.0,
                          soon: true)));
                  Navigator.pop(ctx);
                },
                child: const Text('Publish ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _visible;
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Carpool')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                for (final f in ['All', 'Women only', 'Leaving soon'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No rides match this filter'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _RideCard(
                      ride: list[i],
                      onJoin: () => setState(() => list[i].requested = !list[i].requested),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 72, right: 4),
        child: FloatingActionButton.extended(
          heroTag: 'offer',
          onPressed: _offerRide,
          icon: const Icon(Icons.add),
          label: const Text('Offer ride'),
        ),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onJoin;
  const _RideCard({required this.ride, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ride.womenOnly ? Colors.pink.shade100 : kPrimary.withAlpha(40),
                child: Text(ride.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(ride.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: kPrimary, size: 16),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${ride.rating}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              if (ride.womenOnly)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text('Women only', style: TextStyle(color: Colors.pink.shade700, fontSize: 11)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.trip_origin, size: 16, color: kAccent),
              const SizedBox(width: 6),
              Text(ride.from),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, size: 14, color: Colors.black38),
              ),
              const Icon(Icons.school, size: 16, color: kPrimary),
              const SizedBox(width: 6),
              const Text('Campus'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Colors.black54),
              Text('  ${ride.time}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 16),
              const Icon(Icons.event_seat, size: 16, color: Colors.black54),
              Text('  ${ride.seats} seats', style: const TextStyle(color: Colors.black54)),
              const Spacer(),
              ride.requested
                  ? OutlinedButton(onPressed: onJoin, child: const Text('Requested'))
                  : FilledButton(onPressed: onJoin, child: const Text('Join')),
            ],
          ),
        ],
      ),
    );
  }
}
