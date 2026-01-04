import 'dart:async';
import 'package:flutter/material.dart';
import 'package:de_helper/utility/theme_selector.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SplashScreen({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Alignment _alignment = Alignment.topLeft;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
        
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    
    // Start gradient animation loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _animateGradient();
    });

    Timer(widget.duration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.child,
             transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }
  
  void _animateGradient() {
      if(!mounted) return;
      setState(() {
          _alignment = _alignment == Alignment.topLeft ? Alignment.bottomRight : Alignment.topLeft;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        onEnd: _animateGradient,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: _alignment,
              end: _alignment == Alignment.topLeft ? Alignment.bottomRight : Alignment.topLeft,
              colors: isDark 
                  ? AppGradients.darkBackground.colors 
                  : AppGradients.lightBackground.colors,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                        BoxShadow(
                            color: isDark ? Colors.black26 : Colors.black12,
                            blurRadius: 20,
                            spreadRadius: 5
                        )
                    ]
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/app/splash_animation.gif',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag_outlined,
                        size: 100,
                        color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
