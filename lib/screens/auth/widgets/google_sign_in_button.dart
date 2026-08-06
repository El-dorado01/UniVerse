import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Continue with Google',
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isEnabled ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F2937),
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.8),
              elevation: 0,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _GoogleGLogo(size: 24),
                      const SizedBox(width: 14),
                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontFamily: kBodyFontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that renders the official 4-color Google 'G' logo perfectly.
class _GoogleGLogo extends StatelessWidget {
  const _GoogleGLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleGLogoPainter(),
    );
  }
}

class _GoogleGLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Blue section (Right bar + top right arc)
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(cx + w * 0.45, cy - h * 0.05)
      ..lineTo(cx, cy - h * 0.05)
      ..lineTo(cx, cy + h * 0.12)
      ..lineTo(cx + w * 0.28, cy + h * 0.12)
      ..cubicTo(cx + w * 0.26, cy + h * 0.28, cx + w * 0.15, cy + h * 0.38, cx, cy + h * 0.38)
      ..cubicTo(cx - w * 0.21, cy + h * 0.38, cx - w * 0.38, cy + h * 0.21, cx - w * 0.38, cy)
      ..cubicTo(cx - w * 0.38, cy - h * 0.21, cx - w * 0.21, cy - h * 0.38, cx, cy - h * 0.38)
      ..cubicTo(cx + w * 0.13, cy - h * 0.38, cx + w * 0.24, cy - h * 0.33, cx + w * 0.32, cy - h * 0.25)
      ..lineTo(cx + w * 0.43, cy - h * 0.36)
      ..cubicTo(cx + w * 0.32, cy - h * 0.47, cx + w * 0.17, cy - h * 0.5, cx, cy - h * 0.5)
      ..cubicTo(cx - w * 0.28, cy - h * 0.5, cx - w * 0.5, cy - h * 0.28, cx - w * 0.5, cy)
      ..cubicTo(cx - w * 0.5, cy + h * 0.28, cx - w * 0.28, cy + h * 0.5, cx, cy + h * 0.5)
      ..cubicTo(cx + w * 0.27, cy + h * 0.5, cx + w * 0.47, cy + h * 0.31, cx + w * 0.47, cy)
      ..cubicTo(cx + w * 0.47, cy - h * 0.02, cx + w * 0.46, cy - h * 0.04, cx + w * 0.45, cy - h * 0.05)
      ..close();
    canvas.drawPath(bluePath, paint);

    // Red section (Top arc)
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(cx + w * 0.32, cy - h * 0.25)
      ..lineTo(cx + w * 0.43, cy - h * 0.36)
      ..cubicTo(cx + w * 0.32, cy - h * 0.47, cx + w * 0.17, cy - h * 0.5, cx, cy - h * 0.5)
      ..cubicTo(cx - w * 0.28, cy - h * 0.5, cx - w * 0.5, cy - h * 0.28, cx - w * 0.5, cy)
      ..lineTo(cx - w * 0.38, cy)
      ..cubicTo(cx - w * 0.38, cy - h * 0.21, cx - w * 0.21, cy - h * 0.38, cx, cy - h * 0.38)
      ..cubicTo(cx + w * 0.13, cy - h * 0.38, cx + w * 0.24, cy - h * 0.33, cx + w * 0.32, cy - h * 0.25)
      ..close();
    canvas.drawPath(redPath, paint);

    // Yellow section (Left arc)
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(cx - w * 0.5, cy)
      ..cubicTo(cx - w * 0.5, cy - h * 0.15, cx - w * 0.44, cy - h * 0.28, cx - w * 0.35, cy - h * 0.36)
      ..lineTo(cx - w * 0.24, cy - h * 0.25)
      ..cubicTo(cx - w * 0.32, cy - h * 0.18, cx - w * 0.38, cy - h * 0.1, cx - w * 0.38, cy)
      ..cubicTo(cx - w * 0.38, cy + h * 0.1, cx - w * 0.32, cy + h * 0.18, cx - w * 0.24, cy + h * 0.25)
      ..lineTo(cx - w * 0.35, cy + h * 0.36)
      ..cubicTo(cx - w * 0.44, cy + h * 0.28, cx - w * 0.5, cy + h * 0.15, cx - w * 0.5, cy)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Green section (Bottom arc)
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(cx - w * 0.35, cy + h * 0.36)
      ..lineTo(cx - w * 0.24, cy + h * 0.25)
      ..cubicTo(cx - w * 0.17, cy + h * 0.33, cx - w * 0.08, cy + h * 0.38, cx, cy + h * 0.38)
      ..cubicTo(cx + w * 0.15, cy + h * 0.38, cx + w * 0.26, cy + h * 0.28, cx + w * 0.28, cy + h * 0.12)
      ..lineTo(cx + w * 0.45, cy + h * 0.12)
      ..cubicTo(cx + w * 0.42, cy + h * 0.33, cx + w * 0.24, cy + h * 0.5, cx, cy + h * 0.5)
      ..cubicTo(cx - w * 0.28, cy + h * 0.5, cx - w * 0.44, cy + h * 0.38, cx - w * 0.35, cy + h * 0.36)
      ..close();
    canvas.drawPath(greenPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
