import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Enforce transparent OS status bar so our custom widget shines through
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: AppColors.primaryDark,
      height: statusBarHeight > 0 ? statusBarHeight : 20.0,
    );
  }
}
