import 'package:flutter/material.dart';

class PhysicsDrag extends StatefulWidget {
  static const routeName = '/physics-drag';
  const PhysicsDrag({super.key});

  @override
  State<PhysicsDrag> createState() => _PhysicsDragState();
}

class _PhysicsDragState extends State<PhysicsDrag> {
  final Map<String, bool> _matched = {
    'red': false,
    'green': false,
    'blue': false,
  };

  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag & Match')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Score: $_score', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildDraggables()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTargets()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggables() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _coloredBall('red', Colors.red),
        const SizedBox(height: 20),
        _coloredBall('green', Colors.green),
        const SizedBox(height: 20),
        _coloredBall('blue', Colors.blue),
      ],
    );
  }

  Widget _coloredBall(String id, Color color) {
    return Draggable<String>(
      data: id,
      feedback: Material(
        color: Colors.transparent,
        child: _ballWidget(color, size: 60, shadow: true),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _ballWidget(color, size: 50)),
      child: _ballWidget(color, size: 50),
    );
  }

  Widget _ballWidget(Color color, {double size = 50, bool shadow = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: shadow ? [const BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))] : null,
      ),
    );
  }

  Widget _buildTargets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _colorTarget('red', Colors.red),
        const SizedBox(height: 20),
        _colorTarget('green', Colors.green),
        const SizedBox(height: 20),
        _colorTarget('blue', Colors.blue),
      ],
    );
  }

  Widget _colorTarget(String id, Color color) {
    final matched = _matched[id] ?? false;
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 120,
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: matched ? color.withOpacity(0.7) : Colors.grey.shade200,
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isHovering ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)] : null,
          ),
          child: matched
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text('Matched', style: TextStyle(color: Colors.white)),
                  ],
                )
              : Text(id.toUpperCase()),
        );
      },
      onWillAccept: (data) => data != null,
      onAccept: (data) {
        final correct = data == id;
        setState(() {
          if (correct) {
            _matched[id] = true;
            _score += 1;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correct: $data -> $id')));
          } else {
            _score = (_score > 0) ? _score - 1 : 0;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong! $data does not match $id')));
          }
        });
      },
    );
  }
}