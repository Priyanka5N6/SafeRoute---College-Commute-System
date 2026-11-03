import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class TrackScreen extends StatefulWidget {
  final BusRoute route;
  const TrackScreen({super.key, required this.route});
  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.route;
    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Tracking')),
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final p = _c.value;
          final eta = math.max(1, ((1 - p) * r.etaMin).ceil());
          return Column(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: MapPainter(p, r.stops.length),
                  child: const SizedBox.expand(),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 14)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(r.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kAccent.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Arrives in $eta min',
                              style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < r.stops.length; i++) ...[
                            _StopDot(
                              name: r.stops[i],
                              passed: p >= i / (r.stops.length - 1),
                            ),
                            if (i < r.stops.length - 1)
                              Container(
                                width: 28,
                                height: 2,
                                margin: const EdgeInsets.only(bottom: 18),
                                color: p >= (i + 1) / (r.stops.length - 1)
                                    ? kAccent
                                    : Colors.black12,
                              ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: kPrimary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.driver, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('${r.plate}  |  ${r.seatsFree} seats free',
                                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () => _toast('Calling ${r.driver}...'),
                          icon: const Icon(Icons.call),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () => _toast('Live trip shared with trusted contacts'),
                      icon: const Icon(Icons.share_location),
                      label: const Text('Share live trip'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StopDot extends StatelessWidget {
  final String name;
  final bool passed;
  const _StopDot({required this.name, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(passed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: passed ? kAccent : Colors.black26, size: 20),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

/// Draws a stylised map, the bus route and the moving bus marker.
class MapPainter extends CustomPainter {
  final double progress;
  final int stopCount;
  MapPainter(this.progress, this.stopCount);

  Path _route(Size s) {
    final p = Path();
    p.moveTo(s.width * .12, s.height * .88);
    p.cubicTo(s.width * .10, s.height * .50, s.width * .55, s.height * .85,
        s.width * .50, s.height * .52);
    p.cubicTo(s.width * .46, s.height * .20, s.width * .90, s.height * .50,
        s.width * .86, s.height * .12);
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE8EDF5));

    // Park / water blobs
    canvas.drawOval(
        Rect.fromLTWH(size.width * .60, size.height * .62, size.width * .32, size.height * .22),
        Paint()..color = const Color(0xFFCDE8D0));
    canvas.drawOval(
        Rect.fromLTWH(size.width * .02, size.height * .08, size.width * .30, size.height * .18),
        Paint()..color = const Color(0xFFBBDEFB));

    // Road grid
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7;
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, size.height * i / 5), Offset(size.width, size.height * i / 5), road);
      canvas.drawLine(Offset(size.width * i / 5, 0), Offset(size.width * i / 5, size.height), road);
    }

    final path = _route(size);
    final metric = path.computeMetrics().first;
    final len = metric.length;

    // Full route (grey) and travelled part (green)
    canvas.drawPath(
      path,
      Paint()
        ..color = kPrimary.withAlpha(90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      metric.extractPath(0, len * progress),
      Paint()
        ..color = kAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Stops
    for (int i = 0; i < stopCount; i++) {
      final pos = metric.getTangentForOffset(len * i / (stopCount - 1))!.position;
      canvas.drawCircle(pos, 9, Paint()..color = Colors.white);
      canvas.drawCircle(
          pos, 6, Paint()..color = i == stopCount - 1 ? kDanger : kPrimary);
    }

    // Bus marker
    final bus = metric.getTangentForOffset(len * progress)!.position;
    canvas.drawCircle(bus, 22, Paint()..color = kAccent.withAlpha(50));
    canvas.drawCircle(bus, 15, Paint()..color = Colors.white);
    canvas.drawCircle(bus, 12, Paint()..color = kPrimary);
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.directions_bus.codePoint),
        style: TextStyle(
          fontSize: 16,
          fontFamily: Icons.directions_bus.fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, bus - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant MapPainter old) => old.progress != progress;
}
