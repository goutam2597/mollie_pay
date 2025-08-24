import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final double? iconHeight;
  final double? iconWidth;

  const CustomIconButtonWidget({
    super.key,
    required this.onTap,
    this.height = 38.0,
    this.width = 38.0,
    this.iconHeight,
    this.iconWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(height / 2),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/backIcon.svg',
          height: iconHeight,
          width: iconWidth,
        ),
      ),
    );
  }
}
