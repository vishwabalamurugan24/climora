import 'package:flutter/material.dart';
import '../shims/url_launcher_string.dart';
import '../services/navigation_service.dart';
import '../shims/geolocator.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final NavigationService _nav = NavigationService();
  List<MicroDestination> _places = [];
  bool _loading = false;
  String? _error;

  Future<void> _loadSuggestions() async {
    setState(() { _loading = true; _error = null; });
    try {
      final pos = await Geolocator.getCurrentPosition();
      final list = await _nav.suggestMicroDestinations(pos, mood: 'neutral', comfort: 50.0);
      setState(() { _places = list; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Mood-Friendly Places')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _loadSuggestions, child: const Text('Refresh')),
            const SizedBox(height: 12),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: _places.length,
                itemBuilder: (context, i) {
                  final p = _places[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.category} • ${(p.distanceMeters).toStringAsFixed(0)} m'),
                    leading: Icon(Icons.place),
                    trailing: ElevatedButton(
                      child: const Text('Navigate'),
                      onPressed: () async {
                        final url = 'https://www.google.com/maps/dir/?api=1&destination=${p.lat},${p.lon}';
                        try {
                          final ok = await launchUrlString(url);
                          if (!mounted) return;
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open maps app.')));
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening maps: $e')));
                        }
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

void launchUrl(BuildContext context, String url) async {
  // Use a simple approach: show dialog with URL for user to copy/open.
  showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('Open route'), content: SelectableText(url), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))]));
}
