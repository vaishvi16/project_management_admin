// lib/screens/splash_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _gradientAnimation;
  List<Animation<double>> _particleAnimations = [];

  final int _particleCount = 12;
  final List<Color> _gradientColors = [
    const Color(0xFF667EEA),
    const Color(0xFF764BA2),
    const Color(0xFFF093FB),
    const Color(0xFFF5576C),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Main animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutBack),
      ),
    );

    _gradientAnimation = ColorTween(
      begin: _gradientColors[0],
      end: _gradientColors[1],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Particle animations
    for (int i = 0; i < _particleCount; i++) {
      _particleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.1 + (i * 0.05), 1.0, curve: Curves.easeOut),
          ),
        ),
      );
    }

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // Navigate after animation completes
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Safe animation value getter
  double _getSafeValue(Animation<double> animation) {
    return animation.value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            center: Alignment.center,
            colors: [
              _gradientAnimation.value ?? _gradientColors[0],
              _gradientColors[1],
              _gradientColors[2],
              _gradientColors[3],
              _gradientColors[0],
            ],
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            transform: GradientRotation(_rotationAnimation.value * 3.14159),
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ..._buildParticles(),

            // Background glow effect
            _buildBackgroundGlow(),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main logo with multiple animations
                  SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: RotationTransition(
                          turns: _rotationAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3 * _getSafeValue(_fadeAnimation)),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),

                              // Main logo container
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.7),
                                      Colors.white.withOpacity(0.4),
                                    ],
                                    stops: const [0.1, 0.6, 1.0],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Inner rotating elements
                                    _buildInnerLogoElements(),

                                    // Main icon
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      size: 60,
                                      color: _gradientAnimation.value,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App title with staggered animation
                  _buildAppTitle(),

                  const SizedBox(height: 20),

                  // Loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),

            // Version text at bottom
            _buildVersionText(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    return List.generate(_particleCount, (index) {
      return AnimatedBuilder(
        animation: _particleAnimations[index],
        builder: (context, child) {
          final animationValue = _getSafeValue(_particleAnimations[index]);
          final angle = (index / _particleCount) * 2 * 3.14159;
          final distance = 150.0 * animationValue;

          return Positioned(
            left: MediaQuery.of(context).size.width / 2 +
                distance * math.cos(angle) - 4,
            top: MediaQuery.of(context).size.height / 2 +
                distance * math.sin(angle) - 4,
            child: Transform.rotate(
              angle: angle,
              child: Opacity(
                opacity: 1.0 - animationValue,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildBackgroundGlow() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.white.withOpacity(0.1 * _getSafeValue(_fadeAnimation)),
                  Colors.transparent,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerLogoElements() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: -_rotationAnimation.value * 3.14159,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: CustomPaint(
              painter: _LogoElementsPainter(_rotationAnimation.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _getSafeValue(_fadeAnimation),
          child: Column(
            children: [
              Text(
                'PROJECTFLOW',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enterprise Project Management',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 100,
          height: 4,
          child: LinearProgressIndicator(
            value: _controller.value,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.8),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  Widget _buildVersionText() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _getSafeValue(_fadeAnimation) * 0.7,
            child: const Text(
              'v2.1.0 • © 2024 ProjectFlow Inc.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoElementsPainter extends CustomPainter {
  final double animationValue;

  _LogoElementsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw rotating elements
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * 3.14159 + animationValue * 3.14159;
      final start = Offset(
        center.dx + 35 * math.cos(angle),
        center.dy + 35 * math.sin(angle),
      );
      final end = Offset(
        center.dx + 45 * math.cos(angle),
        center.dy + 45 * math.sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoElementsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
