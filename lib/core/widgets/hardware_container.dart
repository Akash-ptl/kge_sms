import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HardwareContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final Color? accentColor;

  const HardwareContainer({
    super.key, 
    required this.child, 
    this.padding, 
    this.width,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppTheme.primaryColor;
    
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.8),
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          // Corner Brackets
          _buildCorner(Alignment.topLeft, color),
          _buildCorner(Alignment.topRight, color),
          _buildCorner(Alignment.bottomLeft, color),
          _buildCorner(Alignment.bottomRight, color),
          
          // Side Glow (Subtle)
          Positioned(
            left: 0, top: 20, bottom: 20,
            child: Container(width: 1, color: color.withOpacity(0.1)),
          ),
          
          child,
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    return Positioned(
      left: alignment.x == -1 ? 0 : null,
      right: alignment.x == 1 ? 0 : null,
      top: alignment.y == -1 ? 0 : null,
      bottom: alignment.y == 1 ? 0 : null,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y == -1 ? BorderSide(color: color.withOpacity(0.5), width: 1.5) : BorderSide.none,
            bottom: alignment.y == 1 ? BorderSide(color: color.withOpacity(0.5), width: 1.5) : BorderSide.none,
            left: alignment.x == -1 ? BorderSide(color: color.withOpacity(0.5), width: 1.5) : BorderSide.none,
            right: alignment.x == 1 ? BorderSide(color: color.withOpacity(0.5), width: 1.5) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
