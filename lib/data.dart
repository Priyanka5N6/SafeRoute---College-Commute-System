// Mock data used across the app (no backend needed for the lab demo).

class BusRoute {
  final String id, name, driver, plate;
  final int etaMin, seatsFree;
  final List<String> stops;
  const BusRoute({
    required this.id,
    required this.name,
    required this.driver,
    required this.plate,
    required this.etaMin,
    required this.seatsFree,
    required this.stops,
  });
}

const List<BusRoute> routes = [
  BusRoute(
    id: 'R1',
    name: 'Route 1 - Kompally to Campus',
    driver: 'Ramesh Kumar',
    plate: 'TS 08 UB 4521',
    etaMin: 12,
    seatsFree: 9,
    stops: ['Kompally', 'Suchitra', 'Bowenpally', 'Campus'],
  ),
  BusRoute(
    id: 'R2',
    name: 'Route 2 - Secunderabad to Campus',
    driver: 'Suresh Reddy',
    plate: 'TS 09 UC 7734',
    etaMin: 25,
    seatsFree: 4,
    stops: ['Secunderabad', 'Tarnaka', 'Uppal', 'Campus'],
  ),
  BusRoute(
    id: 'R3',
    name: 'Route 3 - Miyapur to Campus',
    driver: 'Anil Sharma',
    plate: 'TS 07 UA 1198',
    etaMin: 38,
    seatsFree: 15,
    stops: ['Miyapur', 'Kukatpally', 'JNTU', 'Campus'],
  ),
];

class Contact {
  String name, relation, phone;
  Contact(this.name, this.relation, this.phone);
}

final List<Contact> trustedContacts = [
  Contact('Mom', 'Family', '+91 98765 43210'),
  Contact('Rahul', 'Friend', '+91 91234 56780'),
];

class Ride {
  final String name, from, time;
  final int seats;
  final double rating;
  final bool womenOnly, soon;
  bool requested;
  Ride({
    required this.name,
    required this.from,
    required this.time,
    required this.seats,
    required this.rating,
    this.womenOnly = false,
    this.soon = false,
    this.requested = false,
  });
}

final List<Ride> rides = [
  Ride(name: 'Ananya S.', from: 'Kukatpally', time: '8:15 AM', seats: 2, rating: 4.9, womenOnly: true, soon: true),
  Ride(name: 'Vikram R.', from: 'Miyapur', time: '8:30 AM', seats: 3, rating: 4.7, soon: true),
  Ride(name: 'Sneha P.', from: 'Secunderabad', time: '9:00 AM', seats: 1, rating: 4.8, womenOnly: true),
  Ride(name: 'Arjun M.', from: 'Uppal', time: '9:20 AM', seats: 2, rating: 4.5),
];
