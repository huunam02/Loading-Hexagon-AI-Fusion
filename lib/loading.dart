import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

class HexagonTechLoading extends StatefulWidget {
  const HexagonTechLoading({super.key});

  @override
  State<HexagonTechLoading> createState() => _HexagonTechLoadingState();
}

class _HexagonTechLoadingState extends State<HexagonTechLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final timeline = controller.value;
        final rotation = timeline * 2 * pi;
        final fusionPhase = 0.5 - 0.5 * cos(timeline * 2 * pi);
        final mergeCurve = Curves.easeInOutCubic.transform(fusionPhase);
        final textMergeCurve = Curves.easeInOutSine.transform(fusionPhase);
        final divergence = 1 - mergeCurve;
        final outerRotation = rotation * (1.05 + 0.25 * divergence);
        final innerRotation = -rotation * (1.18 + 0.32 * mergeCurve);
        final pulse = (0.94 + 0.12 * sin(rotation * 3)) *
            lerpDouble(1.08, 0.9, mergeCurve)!;
        final innerPulse = (0.84 + 0.16 * sin(rotation * 5)) *
            lerpDouble(0.78, 1.06, mergeCurve)!;
        final glow =
            5.5 + 2.8 * (0.5 + 0.5 * sin(rotation * 2)) + mergeCurve * 2.4;
        final haloIntensity =
            0.18 + 0.1 * (0.5 + 0.5 * sin(rotation * 1.5)) + mergeCurve * 0.05;
        final sweepShift = 0.3 + 0.17 * sin(rotation * 2);
        final textGlowPulse =
            0.35 + 0.65 * (0.5 + 0.5 * sin(rotation * 3)) + mergeCurve * 0.2;
        final underlineProgress = 0.5 - 0.5 * cos(timeline * 2 * pi);
        final textZoom =
            1.0 + 0.06 * sin(rotation * 2) + mergeCurve * 0.05;
        final verticalDrift =
            2 * sin(rotation) * (0.6 + 0.4 * mergeCurve);
        final aiShadowColor =
            Colors.cyanAccent.withOpacity(0.2 + haloIntensity * 0.4);
        final fusionShadowColor =
            Colors.cyanAccent.withOpacity(0.3 + haloIntensity * 0.65);
        final aiShadowBlur = 8 + 8 * textGlowPulse;
        final fusionShadowBlur = 12 + 14 * textGlowPulse;
        final baseTextStyle = TextStyle(
          fontSize: 22,
          letterSpacing: 4,
          fontWeight: FontWeight.w800,
          height: 1.1,
          shadows: [
            Shadow(
              color: aiShadowColor,
              blurRadius: aiShadowBlur,
            ),
          ],
        );
        final aiOffsetX = lerpDouble(-68, 0, textMergeCurve)!;
        final fusionOffsetX = lerpDouble(68, 0, textMergeCurve)!;
        final textSpacing = lerpDouble(20, 12, textMergeCurve)!;
        final fusionFlash =
          max(0.0, 1 - (mergeCurve - 0.52).abs() * 3.4).clamp(0.0, 1.0);

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.06),
              radius: 1.2,
              colors: [
                Color.lerp(const Color(0xFF163762), const Color(0xFF0B1124),
                    mergeCurve)!,
                const Color(0xFF05070F),
              ],
              stops: [0.12 + sweepShift * 0.08 + mergeCurve * 0.16, 1],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.22),
                                Colors.transparent,
                              ],
                              stops: const [0, 1],
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(232, 232),
                        painter: EnergyRingPainter(
                          intensity: haloIntensity,
                          shimmerOffset: controller.value,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(236, 236),
                        painter: FusionArcPainter(
                          progress: mergeCurve,
                          rotation: rotation,
                          flashIntensity: fusionFlash,
                        ),
                      ),
                      _buildFusionEnergyBurst(
                        mergeCurve: mergeCurve,
                        fusionFlash: fusionFlash,
                        rotation: rotation,
                      ),
                      Transform.rotate(
                        angle: outerRotation,
                        child: Transform.scale(
                          scale: pulse,
                          child: SizedBox(
                            width: 224,
                            height: 224,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(224, 224),
                                  painter: HexagonGlowPainter(
                                    gradientColors: const [
                                      Color(0xFF2CF0FF),
                                      Color(0xFF7AFDFF),
                                      Color(0xFF1CB4FF),
                                      Color(0xFF2CF0FF),
                                    ],
                                    strokeWidth: 5.2,
                                    blurSigma: 16 + glow,
                                    rotation: rotation,
                                  ),
                                ),
                                CustomPaint(
                                  size: const Size(224, 224),
                                  painter: HexagonPainter(
                                    gradientColors: const [
                                      Color(0xFF4CF6FF),
                                      Color(0xFFA6FEFF),
                                      Color(0xFF00D8FF),
                                      Color(0xFF4CF6FF),
                                    ],
                                    strokeWidth: 4.6,
                                    glowStrength: 0,
                                    rotation: rotation,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: innerRotation,
                        child: Transform.scale(
                          scale: innerPulse,
                          child: SizedBox(
                            width: 152,
                            height: 152,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(152, 152),
                                  painter: HexagonGlowPainter(
                                    gradientColors: const [
                                      Color(0xFF8FE9FF),
                                      Color(0xFFD5FBFF),
                                      Color(0xFF58CFFF),
                                    ],
                                    strokeWidth: 4,
                                    blurSigma: 12 + glow * 0.6,
                                    rotation: innerRotation,
                                  ),
                                ),
                                CustomPaint(
                                  size: const Size(152, 152),
                                  painter: HexagonPainter(
                                    gradientColors: const [
                                      Color(0xFFC1F1FF),
                                      Color(0xFFE2FFFF),
                                      Color(0xFF7FD9FF),
                                    ],
                                    strokeWidth: 3.6,
                                    glowStrength: 0,
                                    rotation: innerRotation,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildOrbitingDots(rotation, mergeCurve),
                      Container(
                        width: lerpDouble(52, 70, fusionFlash)! +
                          10 * sin(rotation * 2),
                        height: lerpDouble(52, 70, fusionFlash)! +
                          10 * sin(rotation * 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.cyanAccent
                                  .withOpacity(0.82 + 0.16 * fusionFlash),
                              Colors.cyanAccent
                                  .withOpacity(0.22 + 0.35 * fusionFlash),
                              Colors.transparent,
                            ],
                            stops: const [0.1, 0.5, 1],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent
                                  .withOpacity(0.42 + 0.3 * fusionFlash),
                              blurRadius: 16 + glow * 0.9 + fusionFlash * 6,
                              spreadRadius: 1.6 + fusionFlash * 2.4,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18 +
                                0.18 * fusionFlash),
                            width: 1.2,
                          ),
                        ),
                        child: _buildFusionCore(fusionFlash, rotation),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Container(
                          width: 164,
                          height: 1.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.05),
                                Colors.cyanAccent
                                    .withOpacity(0.18 + haloIntensity),
                                Colors.cyanAccent.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFusionTitle(
                      rotation: rotation,
                      textZoom: textZoom,
                      verticalDrift: verticalDrift,
                      aiOffsetX: aiOffsetX,
                      fusionOffsetX: fusionOffsetX,
                      textSpacing: textSpacing,
                      baseTextStyle: baseTextStyle,
                      aiShadowColor: aiShadowColor,
                      aiShadowBlur: aiShadowBlur,
                      fusionShadowColor: fusionShadowColor,
                      fusionShadowBlur: fusionShadowBlur,
                      fusionFlash: fusionFlash,
                    ),
                    const SizedBox(height: 12),
                    _buildAnimatedTextUnderline(
                      underlineProgress,
                      haloIntensity,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HexagonPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;
  final double glowStrength;
  final double rotation;

  HexagonPainter({
    required this.gradientColors,
    required this.strokeWidth,
    required this.glowStrength,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: gradientColors,
        startAngle: 0,
        endAngle: 2 * pi,
        transform: GradientRotation(rotation),
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = glowStrength > 0
          ? MaskFilter.blur(BlurStyle.normal, glowStrength)
          : null;

    final path = Path();
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HexagonGlowPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;
  final double blurSigma;
  final double rotation;

  HexagonGlowPainter({
    required this.gradientColors,
    required this.strokeWidth,
    required this.blurSigma,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        colors: gradientColors,
        startAngle: 0,
        endAngle: 2 * pi,
        transform: GradientRotation(rotation),
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    final path = Path();
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FusionArcPainter extends CustomPainter {
  final double progress;
  final double rotation;
  final double flashIntensity;

  FusionArcPainter({
    required this.progress,
    required this.rotation,
    required this.flashIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = lerpDouble(pi * 0.95, pi * 0.58, progress)!;
    final separation = lerpDouble(pi * 0.62, pi * 0.2, progress)!;
    final baseAngle = -pi / 2 + rotation * 0.05;
    final thickness = lerpDouble(4.2, 6.4, progress)!;
    final blur = 10 + flashIntensity * 12;

    for (final direction in [-1, 1]) {
      final start = baseAngle + direction * separation / 2 - sweep / 2;
      final blendColor = direction == -1
          ? Color.lerp(const Color(0xFF55F3FF), const Color(0xFF18B2FF),
              progress)!
          : Color.lerp(const Color(0xFFB0FFFF), const Color(0xFF3DD0FF),
              progress)!;

      final mainPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round
        ..color = blendColor.withOpacity(0.32 + 0.48 * flashIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

      canvas.drawArc(rect, start, sweep, false, mainPaint);

      final highlightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness * 0.55
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withOpacity(0.18 + flashIntensity * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 0.6);

      canvas.drawArc(rect, start + sweep * 0.12, sweep * 0.74, false,
          highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget _buildOrbitingDots(double rotation, double mergeCurve) {
  const baseSize = 240.0;
  final center = baseSize / 2;
  final tightenedRadius = lerpDouble(96, 68, mergeCurve)!;
  final trailWave = 6 + 8 * (1 - mergeCurve);

  return SizedBox(
    width: baseSize,
    height: baseSize,
    child: Stack(
      children: List.generate(3, (index) {
        final angle = rotation + (2 * pi / 3) * index;
        final wavePhase = rotation * 4 + (2 * pi / 3) * index;
        final radius = tightenedRadius + trailWave * sin(wavePhase);
        final dx = center + radius * cos(angle);
        final dy = center + radius * sin(angle);
        final dotSize = lerpDouble(18, 14, mergeCurve)!;
        final haloOpacity = 0.32 + 0.28 * (1 - mergeCurve);

        return Positioned(
          left: dx - dotSize / 2,
          top: dy - dotSize / 2,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.cyanAccent.withOpacity(0.82),
                  Colors.cyanAccent.withOpacity(0.12),
                ],
                stops: const [0.1, 0.58, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(haloOpacity),
                  blurRadius: 12 + 8 * (1 - mergeCurve),
                  spreadRadius: 1 + 1.1 * (1 - mergeCurve),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 0.6,
              ),
            ),
          ),
        );
      }),
    ),
  );
}

class FusionCrossAuraPainter extends CustomPainter {
  final double opacity;
  final double rotation;
  final double thickness;
  final double halfLength;

  FusionCrossAuraPainter({
    required this.opacity,
    required this.rotation,
    required this.thickness,
    required this.halfLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0),
          Colors.cyanAccent.withOpacity(opacity * 0.8),
          Colors.cyanAccent.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 + opacity * 24);

    final verticalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: thickness * 0.9,
      height: halfLength * 2.2,
    );

    final horizontalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: halfLength * 2.2,
      height: thickness * 0.9,
    );

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation * 0.08);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawRRect(
      RRect.fromRectXY(verticalRect, thickness, thickness),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectXY(horizontalRect, thickness, thickness),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget _buildAnimatedTextUnderline(double progress, double haloIntensity) {
  final alignmentX = progress * 2 - 1;

  return SizedBox(
    width: 180,
    height: 8,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0),
                Colors.cyanAccent.withOpacity(0.18 + haloIntensity * 0.45),
                Colors.cyanAccent.withOpacity(0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(alignmentX, 0),
          child: Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0),
                  Colors.cyanAccent.withOpacity(0.85),
                  Colors.cyanAccent.withOpacity(0),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent
                      .withOpacity(0.3 + haloIntensity * 0.3),
                  blurRadius: 10,
                  spreadRadius: 0.6,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFusionEnergyBurst({
  required double mergeCurve,
  required double fusionFlash,
  required double rotation,
}) {
  final haloOpacity = 0.08 + mergeCurve * 0.22;
  final crossOpacity = 0.18 + fusionFlash * 0.52;
  final bladeWidth = lerpDouble(96, 142, fusionFlash)!;
  final bladeHeight = lerpDouble(10, 24, fusionFlash)!;
  final ringSize = lerpDouble(118, 94, mergeCurve)!;
  final ringStroke = lerpDouble(1.2, 2.4, fusionFlash)!;

  return IgnorePointer(
    ignoring: true,
    child: SizedBox(
      width: 236,
      height: 236,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 236,
            height: 236,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(haloOpacity),
                  Colors.transparent,
                ],
                stops: const [0, 1],
              ),
            ),
          ),
          Transform.rotate(
            angle: rotation * 0.35,
            child: Container(
              width: bladeWidth,
              height: bladeHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(bladeHeight),
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0),
                    Colors.cyanAccent.withOpacity(crossOpacity),
                    Colors.cyanAccent.withOpacity(0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.cyanAccent.withOpacity(crossOpacity * 0.7),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: rotation * 0.35 + pi / 2,
            child: Container(
              width: bladeWidth,
              height: bladeHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(bladeHeight),
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0),
                    Colors.cyanAccent.withOpacity(crossOpacity * 0.9),
                    Colors.cyanAccent.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: ringSize,
            height: ringSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.12 + fusionFlash * 0.3),
                width: ringStroke,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFusionCore(double fusionFlash, double rotation) {
  final blur = 10 + fusionFlash * 12;
  final crossOpacity = 0.42 + fusionFlash * 0.45;
  final crossThickness = lerpDouble(3.8, 6.2, fusionFlash)!;
  final crossLength = lerpDouble(34, 46, fusionFlash)!;
  final ringOpacity = 0.32 + fusionFlash * 0.4;

  return SizedBox(
    width: 38 + fusionFlash * 12,
    height: 38 + fusionFlash * 12,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0.76 + fusionFlash * 0.18),
                Colors.cyanAccent.withOpacity(0.18 + fusionFlash * 0.18),
                Colors.transparent,
              ],
              stops: const [0.24, 0.7, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.46 + fusionFlash * 0.2),
                blurRadius: blur,
                spreadRadius: 2.6,
              ),
            ],
          ),
        ),
        Container(
          width: 28 + fusionFlash * 10,
          height: 28 + fusionFlash * 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(ringOpacity),
              width: 1.4 + fusionFlash * 0.8,
            ),
          ),
        ),
        _buildFusionCross(
          opacity: crossOpacity,
          thickness: crossThickness,
          length: crossLength,
          rotation: rotation,
        ),
      ],
    ),
  );
}

Widget _buildFusionCross({
  required double opacity,
  required double thickness,
  required double length,
  required double rotation,
}) {
  final half = length / 2;

  return IgnorePointer(
    ignoring: true,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(thickness),
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0),
                Colors.cyanAccent.withOpacity(opacity),
                Colors.cyanAccent.withOpacity(0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(opacity * 0.65),
                blurRadius: 22,
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: pi / 2,
          child: Container(
            width: length,
            height: thickness,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(thickness),
              gradient: LinearGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0),
                  Colors.cyanAccent.withOpacity(opacity * 1.1),
                  Colors.cyanAccent.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: FusionCrossAuraPainter(
              opacity: opacity,
              rotation: rotation,
              thickness: thickness,
              halfLength: half,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFusionTitle({
  required double rotation,
  required double textZoom,
  required double verticalDrift,
  required double aiOffsetX,
  required double fusionOffsetX,
  required double textSpacing,
  required TextStyle baseTextStyle,
  required Color aiShadowColor,
  required double aiShadowBlur,
  required Color fusionShadowColor,
  required double fusionShadowBlur,
  required double fusionFlash,
}) {
  return Transform.translate(
    offset: Offset(0, verticalDrift),
    child: Transform.scale(
      scale: textZoom,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.22 + 0.55 * fusionFlash,
            child: Container(
              width: 116,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0),
                    Colors.cyanAccent.withOpacity(0.3 + fusionFlash * 0.45),
                    Colors.cyanAccent.withOpacity(0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent
                        .withOpacity(0.24 + fusionFlash * 0.36),
                    blurRadius: 20,
                    spreadRadius: 2.4,
                  ),
                ],
              ),
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: const [
                  Color(0xFFE5FDFF),
                  Color(0xFF74C8FF),
                  Color(0xFFE5FDFF),
                ],
                stops: const [0, 0.5, 1],
                transform: GradientRotation(rotation * 0.6),
              ).createShader(bounds);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(aiOffsetX, 0),
                  child: Text(
                    'AI',
                    style: baseTextStyle.copyWith(
                      shadows: [
                        Shadow(
                          color: aiShadowColor,
                          blurRadius: aiShadowBlur,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: textSpacing),
                Transform.translate(
                  offset: Offset(fusionOffsetX, 0),
                  child: Text(
                    'FUSION',
                    style: baseTextStyle.copyWith(
                      fontSize: 24,
                      letterSpacing: 7,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: fusionShadowColor,
                          blurRadius: fusionShadowBlur,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: fusionFlash,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.78),
                    Colors.cyanAccent.withOpacity(0.18),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.68, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class EnergyRingPainter extends CustomPainter {
  final double intensity;
  final double shimmerOffset;

  EnergyRingPainter({required this.intensity, required this.shimmerOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2.4,
    );

    final sweep = (0.3 + intensity) * 2 * pi;
    final startAngle = shimmerOffset * 2 * pi;

    final paint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweep,
        colors: [
          Colors.cyanAccent.withOpacity(0),
          Colors.cyanAccent.withOpacity(0.7 + intensity * 0.5),
          Colors.cyanAccent.withOpacity(0),
        ],
        stops: const [0, 0.5, 1],
      ).createShader(rect)
      ..strokeWidth = 4.6
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12 + intensity * 12);

    canvas.drawArc(rect, startAngle, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant EnergyRingPainter oldDelegate) {
    return oldDelegate.intensity != intensity ||
        oldDelegate.shimmerOffset != shimmerOffset;
  }
}
