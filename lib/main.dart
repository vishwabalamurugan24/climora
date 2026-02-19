import 'package:flutter/material.dart';
import 'screens/stt_emotion.dart';
import 'screens/weather_screen.dart';
import 'screens/navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodSync Prototype',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MoodSync Home'),
      routes: {
        '/stt': (_) => const SttEmotionScreen(),
        '/weather': (_) => const WeatherScreen(),
        '/navigation': (_) => const NavigationScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to MoodSync prototype'),
            const SizedBox(height: 12),
            Text(
              'Button pressed: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Simulate action'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (context.mounted) Navigator.pushNamed(context, '/stt');
              },
              child: const Text('Open STT + Emotion'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (context.mounted) Navigator.pushNamed(context, '/weather');
              },
              child: const Text('Open Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
