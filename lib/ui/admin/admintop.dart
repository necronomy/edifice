import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:mybuilding/const.dart';

class AdminTop extends StatefulWidget {
  const AdminTop({super.key});

  @override
  State<AdminTop> createState() => _AdminTopState();
}

class _AdminTopState extends State<AdminTop> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          height: MediaQuery.of(context).viewPadding.top,
          width: double.maxFinite,
          decoration: MyDecoration.boxDecoration
              .copyWith(borderRadius: BorderRadius.zero, color: MyColors.bgColor.withOpacity(0.59)),
        ),
      ),
    );
  }
}
