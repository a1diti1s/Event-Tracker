// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class CircularCountdown extends StatelessWidget {
//   final int daysLeft;
//   final int totalDays;

//   const CircularCountdown({
//     Key? key,
//     required this.daysLeft,
//     this.totalDays = 7,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Calculate progress (0.0 to 1.0)
//     // When days are remaining, show progress clockwise
//     final progress = daysLeft > 0 ? (totalDays - daysLeft) / totalDays : 1.0;

//     return SizedBox(
//       width: 120,
//       height: 120,
//       child: CustomPaint(
//         painter: CircularCountdownPainter(progress: progress, strokeWidth: 12),
//       ),
//     );
//   }
// }

// class CircularCountdownPainter extends CustomPainter {
//   final double progress;
//   final double strokeWidth;

//   CircularCountdownPainter({required this.progress, required this.strokeWidth});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;

//     // Background circle (track)
//     final backgroundPaint = Paint()
//       ..color = const Color(0xFF2A3442)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;

//     canvas.drawCircle(center, radius, backgroundPaint);

//     // Progress arc
//     final progressPaint = Paint()
//       ..color =
//           const Color(0xFFFFA500) // Orange color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;

//     // Draw arc from top, clockwise
//     const startAngle = -math.pi / 2; // Start from top
//     final sweepAngle = 2 * math.pi * progress;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       progressPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CircularCountdownPainter oldDelegate) {
//     return oldDelegate.progress != progress;
//   }
// }

import 'package:flutter/material.dart';
import 'dart:math';

class CircularCountdown extends StatefulWidget {
  final int daysLeft;
  final int totalDays;

  const CircularCountdown({
    Key? key,
    required this.daysLeft,
    required this.totalDays,
  }) : super(key: key);

  @override
  _CircularCountdownState createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    double progress =
        (widget.daysLeft > 0 ? widget.daysLeft : 0) / widget.totalDays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    double newProgress =
        (widget.daysLeft > 0 ? widget.daysLeft : 0) / widget.totalDays;

    _animation = Tween<double>(
      begin: _animation.value,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CountdownPainter(progress: _animation.value),
            child: Center(
              child: Text(
                '${widget.daysLeft > 0 ? widget.daysLeft : 0}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CountdownPainter extends CustomPainter {
  final double progress;

  _CountdownPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = const Color(0xFF2A3442)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Yellow progress arc
    final progressPaint = Paint()
      ..color = const Color(0xFFFFA500)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc (yellow)
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CountdownPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
