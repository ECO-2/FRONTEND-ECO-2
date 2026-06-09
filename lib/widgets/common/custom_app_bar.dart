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
  final Color? statusBarColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.statusBarColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      if (canPop) {
        leadingWidget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              customBorder: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: foregroundColor == Colors.white
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.1),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: foregroundColor,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }
    }

    List<Widget>? appBarActions = actions;
    if (appBarActions == null && title != null) {
      appBarActions = [
        IconButton(
          icon: Icon(
            Icons.more_horiz_rounded,
            color: foregroundColor,
            size: 28,
          ),
          onPressed: () {},
        ),
      ];
    }

    final actualStatusBarColor = statusBarColor ??
        (backgroundColor == AppColors.primary
            ? AppColors.primaryDark
            : backgroundColor);

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(actualStatusBarColor) == Brightness.dark;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AppBar(
      primary: true,
      toolbarHeight: 72.0,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            )
          : null,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leadingWidget,
      iconTheme: IconThemeData(color: foregroundColor),
      actions: appBarActions,
      bottom: bottom,
      flexibleSpace: Column(
        children: [
          Container(
            height: statusBarHeight,
            color: actualStatusBarColor,
          ),
          Expanded(
            child: Container(
              color: backgroundColor,
            ),
          ),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkBackground ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkBackground ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        72.0 + (bottom?.preferredSize.height ?? 0.0),
      );
}
