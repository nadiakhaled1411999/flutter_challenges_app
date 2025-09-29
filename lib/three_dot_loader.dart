import 'package:flutter/material.dart';

class ThreeDotLoaderPage extends StatefulWidget {
  static const routeName = '/three-dot-loader';
  const ThreeDotLoaderPage({super.key});

  @override
  State<ThreeDotLoaderPage> createState() => _ThreeDotLoaderPageState();
}

class _ThreeDotLoaderPageState extends State<ThreeDotLoaderPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleA;
  late final Animation<double> _opacityA;
  late final Animation<double> _scaleB;
  late final Animation<double> _opacityB;
  late final Animation<double> _scaleC;
  late final Animation<double> _opacityC;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _scaleA = Tween(begin: 0.6, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));
    _opacityA = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)));

    _scaleB = Tween(begin: 0.6, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)));
    _opacityB = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6, curve: Curves.easeIn)));

    _scaleC = Tween(begin: 0.6, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeOut)));
    _opacityC = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> scale, Animation<double> opacity) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: Container(width: 18, height: 18, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Three-dot Loader')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(_scaleA, _opacityA),
            const SizedBox(width: 8),
            _dot(_scaleB, _opacityB),
            const SizedBox(width: 8),
            _dot(_scaleC, _opacityC),
          ],
        ),
      ),
    );
  }
}
