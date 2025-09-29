// ------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_challenges_app/dismissible_reorderable.dart';
import 'package:flutter_challenges_app/physics_drag.dart';
import 'package:flutter_challenges_app/three_dot_loader.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Flutter Widget Challenges',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        Challenge1DismissibleReorderable.routeName: (_) => const Challenge1DismissibleReorderable(),
        PhysicsDrag.routeName: (_) => const PhysicsDrag(),
        ThreeDotLoaderPage.routeName: (_) => const ThreeDotLoaderPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Widget Challenges')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Challenge1DismissibleReorderable.routeName),
              child: const Text('Challenge 1 — ToDo Checklist'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, PhysicsDrag.routeName),
              child: const Text('Challenge 2 — Drag & Match'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, ThreeDotLoaderPage.routeName),
              child: const Text('Challenge 3 — Three-dot Loader'),
            ),
          ],
        ),
      ),
    );
  }
}