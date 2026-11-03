import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});
  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  bool _sent = false;

  late final AnimationController _hold = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _sent = true);
    });

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _hold.dispose();
    _pulse.dispose();
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
    return Scaffold(
      backgroundColor: _sent ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
      appBar: AppBar(
        backgroundColor: _sent ? kAccent : kDanger,
        title: const Text('Emergency SOS'),
      ),
      body: _sent ? _sentView() : _idleView(),
    );
  }

  Widget _idleView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text('Press and hold the button for 3 seconds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('Your live location will be sent to trusted contacts and campus security.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          const Spacer(),
          Listener(
            onPointerDown: (_) => _hold.forward(),
            onPointerUp: (_) => _hold.reverse(),
            onPointerCancel: (_) => _hold.reverse(),
            child: AnimatedBuilder(
              animation: Listenable.merge([_hold, _pulse]),
              builder: (context, _) {
                final t = _pulse.value;
                return SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 170 + 90 * t,
                        height: 170 + 90 * t,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kDanger.withAlpha((70 * (1 - t)).toInt()),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: _hold.value,
                          strokeWidth: 9,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation(kDanger),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 160,
                        decoration: const BoxDecoration(
                          color: kDanger,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app, color: Colors.white, size: 40),
                            SizedBox(height: 4),
                            Text('HOLD', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toast('Fake call will ring in 5 seconds'),
                  icon: const Icon(Icons.phone_callback),
                  label: const Text('Fake call'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toast('Calling Campus Security...'),
                  icon: const Icon(Icons.local_police),
                  label: const Text('Security'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _sentView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.check_circle, color: kAccent, size: 90),
          const SizedBox(height: 12),
          const Text('Alert sent!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Help is on the way. Stay calm.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardBox(),
            child: Column(
              children: [
                _tick('Live location shared'),
                _tick('${trustedContacts.length} trusted contacts notified'),
                _tick('Campus security alerted'),
                _tick('Audio recording started'),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kAccent),
            onPressed: () {
              _hold.reset();
              setState(() => _sent = false);
            },
            child: const Text("I'm safe - cancel alert"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _tick(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.check, color: kAccent),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
          ],
        ),
      );
}
