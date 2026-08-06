import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Camera pan + logo fade/scale.
  late final AnimationController _sceneController;
  late final Animation<double> _panAnimation;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  // Single shimmer sweep across the logo once it has settled.
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  static const _holdBeforeNavigating = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _sceneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _panAnimation = CurvedAnimation(
      parent: _sceneController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
    );
    _logoOpacity = CurvedAnimation(
      parent: _sceneController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _sceneController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );

    _sceneController.forward();
    _sceneController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shimmerController.forward();
      }
    });
    _shimmerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(_holdBeforeNavigating, () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _sceneController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = constraints.biggest;
          final tallHeight = viewportSize.height * 1.8;
          final maxPan = tallHeight - viewportSize.height;

          return Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxHeight: tallHeight,
                  minHeight: tallHeight,
                  child: AnimatedBuilder(
                    animation: _panAnimation,
                    builder: (context, child) {
                      final pan = maxPan * _panAnimation.value;
                      return Transform.translate(
                        offset: Offset(0, -pan),
                        child: child,
                      );
                    },
                    // Painted once and cached: the sky/clouds never change,
                    // only the Transform offset above animates each frame.
                    child: RepaintBoundary(
                      child: CustomPaint(
                        size: Size(viewportSize.width, tallHeight),
                        painter: _SkyPainter(),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: AnimatedBuilder(
                      animation: _shimmerAnimation,
                      builder: (context, _) {
                        return ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: const [
                                Colors.white,
                                Color(0xFFEAF3FF),
                                Colors.white,
                              ],
                              stops: const [0.35, 0.5, 0.65],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              transform: _SlidingGradientTransform(
                                _shimmerAnimation.value,
                              ),
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'UniVerse',
                            style: TextStyle(
                              fontFamily: kLogoFontFamily,
                              fontSize: 48,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Shifts a gradient horizontally across its bounds, producing a sliding
/// highlight band used for the logo's shimmer pass.
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (slidePercent * 3 - 1.5),
      0,
      0,
    );
  }
}

/// Paints a tall, bright daytime sky: deep azure at the top softening into
/// pale blue-white near the bottom, with a few soft, wispy high-altitude
/// clouds. The canvas is taller than the viewport so it can be panned
/// downward to simulate a slow, descending camera move.
class _SkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skyRect = Offset.zero & size;
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF11336B),
          Color(0xFF1D4B8F),
          AppColors.primary,
          Color(0xFF7FA8DE),
          Color(0xFFDCE9F9),
          Colors.white,
        ],
        stops: [0.0, 0.2, 0.42, 0.62, 0.82, 1.0],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // All cloud lobes are collected into a single path so the (expensive)
    // blur is applied once for the whole sky instead of once per cloud.
    const clouds = [
      _CloudSpec(dyFrac: 0.05, dxFrac: 0.5, wFrac: 0.95, hFrac: 0.05),
      _CloudSpec(dyFrac: 0.14, dxFrac: 0.22, wFrac: 0.6, hFrac: 0.035),
      _CloudSpec(dyFrac: 0.15, dxFrac: 0.78, wFrac: 0.5, hFrac: 0.03),
      _CloudSpec(dyFrac: 0.24, dxFrac: 0.4, wFrac: 0.85, hFrac: 0.045),
      _CloudSpec(dyFrac: 0.33, dxFrac: 0.68, wFrac: 0.55, hFrac: 0.03),
    ];

    final cloudPath = Path();
    const lobes = [-0.4, 0.0, 0.4];
    for (final cloud in clouds) {
      final center = Offset(size.width * cloud.dxFrac, size.height * cloud.dyFrac);
      final width = size.width * cloud.wFrac;
      final height = size.height * cloud.hFrac;
      for (final dx in lobes) {
        final lobeWidth = width * (0.55 + 0.2 * (1 - dx.abs()));
        cloudPath.addOval(
          Rect.fromCenter(
            center: center + Offset(width * dx, height * dx * 0.35),
            width: lobeWidth,
            height: height,
          ),
        );
      }
    }

    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(cloudPath, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant _SkyPainter oldDelegate) => false;
}

class _CloudSpec {
  const _CloudSpec({
    required this.dyFrac,
    required this.dxFrac,
    required this.wFrac,
    required this.hFrac,
  });

  final double dyFrac;
  final double dxFrac;
  final double wFrac;
  final double hFrac;
}
