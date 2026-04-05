import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:math' as math;

class CircuitBackground extends StatelessWidget {
  final Widget child;
  const CircuitBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid Floor
        _buildGrid(),
        
        // Circuit Patterns
        Positioned.fill(
          child: CustomPaint(
            painter: _CircuitLinePainter(),
          ),
        ),
        
        // Scanlines Overlay (very subtle)
        _buildScanlines(),

        // The content
        child,
      ],
    );
  }

  Widget _buildGrid() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              AppTheme.primaryColor.withOpacity(0.05),
              AppTheme.darkBg.withOpacity(0.0),
            ],
          ),
        ),
        child: CustomPaint(
          painter: _GridPainter(),
        ),
      ),
    );
  }

  Widget _buildScanlines() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Column(
          children: List.generate(
            100,
            (index) => Container(
              height: 1,
              color: Colors.white.withOpacity(index % 2 == 0 ? 0.005 : 0.0),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;
    
    // Vertical lines
    for (double i = 0; i <= size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    // Horizontal lines
    for (double i = 0; i <= size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircuitLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Seed for consistency

    // Draw some circuit "traces"
    for (int i = 0; i < 8; i++) {
       double startX = random.nextDouble() * size.width;
       double startY = random.nextDouble() * size.height;
       
       final path = Path()..moveTo(startX, startY);
       
       double currentX = startX;
       double currentY = startY;

       // Draw a few segments for each trace
       for (int step = 0; step < 4; step++) {
          double dx = (random.nextBool() ? 1 : -1) * (50 + random.nextDouble() * 100);
          double dy = (random.nextBool() ? 1 : -1) * (50 + random.nextDouble() * 100);
          
          // Circuit lines often turn at 45 or 90 degrees
          if (random.nextBool()) { // 90 degree
             if (random.nextBool()) currentX += dx; else currentY += dy;
          } else { // 45 degree
             currentX += dx;
             currentY += dy;
          }
          
          path.lineTo(currentX, currentY);
          
          // Draw small nodes/solder points
          canvas.drawCircle(Offset(currentX, currentY), 3, dotPaint);
       }
       
       canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
