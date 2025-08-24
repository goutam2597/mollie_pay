import 'package:flutter/material.dart';
import 'package:mollie_pay/widgets/custom_icon_button_widgets.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onTap,
    this.icon = 'assets/backIcon.svg',
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurStyle: BlurStyle.solid,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        foregroundColor: Colors.transparent,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: CustomIconButtonWidget(
                assetPath: widget.icon,
                onTap: widget.onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
