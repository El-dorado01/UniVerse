import 'package:flutter/material.dart';

/// Clips a rect into an organic, cloud-like blob: a scalloped top edge made
/// of rounded bumps, gentler bumps along the bottom, and rounded corners.
class CloudClipper extends CustomClipper<Path> {
  const CloudClipper({
    this.topBumps = 3,
    this.topAmplitude = 34,
    this.bottomBumps = 3,
    this.bottomAmplitude = 24,
    this.cornerRadius = 30,
  });

  final int topBumps;
  final double topAmplitude;
  final int bottomBumps;
  final double bottomAmplitude;
  final double cornerRadius;

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final radius = cornerRadius.clamp(0.0, width / 2);
    final path = Path()..moveTo(radius, 0);

    final topSpan = width - radius * 2;
    final topSegment = topSpan / topBumps;
    for (var i = 0; i < topBumps; i++) {
      final startX = radius + topSegment * i;
      final midX = startX + topSegment / 2;
      final endX = startX + topSegment;
      // Notches dip inward (positive y) rather than bulge outward: content
      // only exists within the box, so an outward-bulging clip would just
      // reveal nothing. Control offset is doubled since a quadratic
      // Bezier's peak only reaches half the control point's offset.
      path.quadraticBezierTo(midX, topAmplitude * 2, endX, 0);
    }

    path.quadraticBezierTo(width, 0, width, radius);
    path.lineTo(width, height - radius);
    path.quadraticBezierTo(width, height, width - radius, height);

    final bottomSpan = width - radius * 2;
    final bottomSegment = bottomSpan / bottomBumps;
    for (var i = 0; i < bottomBumps; i++) {
      final startX = width - radius - bottomSegment * i;
      final midX = startX - bottomSegment / 2;
      final endX = startX - bottomSegment;
      path.quadraticBezierTo(midX, height - bottomAmplitude * 2, endX, height);
    }

    path.quadraticBezierTo(0, height, 0, height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CloudClipper oldClipper) {
    return topBumps != oldClipper.topBumps ||
        topAmplitude != oldClipper.topAmplitude ||
        bottomBumps != oldClipper.bottomBumps ||
        bottomAmplitude != oldClipper.bottomAmplitude ||
        cornerRadius != oldClipper.cornerRadius;
  }
}

/// A photo clipped into a [CloudClipper] blob with a solid-color outline,
/// matching the scalloped "cloud" frame used across onboarding.
class CloudPhotoFrame extends StatelessWidget {
  const CloudPhotoFrame({
    super.key,
    required this.imagePath,
    this.borderColor = const Color(0xFF295EAD),
    this.borderWidth = 7,
  });

  final String imagePath;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    const clipper = CloudClipper();
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(clipper: clipper, child: ColoredBox(color: borderColor)),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(borderWidth),
            child: ClipPath(
              clipper: clipper,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
