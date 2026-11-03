import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _autoShare = true, _nightAlerts = true, _notifyStart = false;

  void _addContact() {
    final name = TextEditingController();
    final phone = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add trusted contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty || phone.text.trim().isEmpty) return;
              setState(() => trustedContacts
                  .add(Contact(name.text.trim(), 'Contact', phone.text.trim())));
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardBox(),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: kPrimary,
                  child: Text('PS', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priya Sharma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('21CS1042  |  B.Tech CSE, 3rd Year', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.verified, color: kAccent, size: 16),
                          Text(' Verified student', style: TextStyle(color: kAccent, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text('Trusted contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(onPressed: _addContact, icon: const Icon(Icons.add), label: const Text('Add')),
            ],
          ),
          if (trustedContacts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No contacts yet. Add someone you trust.'),
            ),
          for (final c in List<Contact>.from(trustedContacts))
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: cardBox(),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: kAccent.withAlpha(40),
                  child: Text(c.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                title: Text(c.name),
                subtitle: Text('${c.relation}  |  ${c.phone}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: kDanger),
                  onPressed: () => setState(() => trustedContacts.remove(c)),
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text('Safety settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: cardBox(),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-share live location'),
                  subtitle: const Text('During every bus or carpool trip'),
                  value: _autoShare,
                  onChanged: (v) => setState(() => _autoShare = v),
                ),
                SwitchListTile(
                  title: const Text('Night travel alerts'),
                  subtitle: const Text('Reminders after 7 PM'),
                  value: _nightAlerts,
                  onChanged: (v) => setState(() => _nightAlerts = v),
                ),
                SwitchListTile(
                  title: const Text('Notify contacts when trip starts'),
                  value: _notifyStart,
                  onChanged: (v) => setState(() => _notifyStart = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: kDanger,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen())),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
