import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color backgroundColor;
  final Color foregroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor = AppColors.primaryDark,
    this.foregroundColor = Colors.white,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            )
          : null,
      centerTitle: false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      iconTheme: IconThemeData(color: foregroundColor),
      actions: actions,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: backgroundColor == Colors.white ? Brightness.dark : Brightness.light,
        statusBarBrightness: backgroundColor == Colors.white ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
