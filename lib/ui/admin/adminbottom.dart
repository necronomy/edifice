import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybuilding/const.dart';

class AdminBottom extends StatefulWidget {
  const AdminBottom({super.key, required this.changeUI, required this.uiIndex});
  final Function changeUI;
  final int uiIndex;
  @override
  State<AdminBottom> createState() => _AdminBottomState();
}

class _AdminBottomState extends State<AdminBottom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
        child: Container(
          height: MediaQuery.of(context).viewPadding.bottom > 19
              ? 55 + MediaQuery.of(context).viewPadding.bottom
              : 69,
          width: double.maxFinite,
          decoration: MyDecoration.boxDecoration.copyWith(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
              color: MyColors.bgColor.withOpacity(0.59)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5).copyWith(bottom: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.uiIndex != 0) {
                            HapticFeedback.lightImpact();
                            SystemSound.play(SystemSoundType.click);
                            widget.changeUI(0);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Icon(
                                Icons.widgets_rounded,
                                size: 39,
                                color: widget.uiIndex == 0
                                    ? Colors.deepPurple
                                    : MyColors.secondaryColor.withOpacity(0.69),
                              ),
                              Text("Asosiy",
                                  style: MyDecoration.textStyle.copyWith(
                                      color: widget.uiIndex == 0
                                          ? Colors.deepPurple
                                          : MyColors.secondaryColor.withOpacity(0.69),
                                      fontSize: 15,
                                      fontWeight:
                                          widget.uiIndex == 0 ? FontWeight.w600 : FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.uiIndex != 1) {
                        HapticFeedback.lightImpact();
                        SystemSound.play(SystemSoundType.click);
                        widget.changeUI(1);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Icon(
                            Icons.wysiwyg_rounded,
                            size: 39,
                            color: widget.uiIndex == 1
                                ? Colors.deepPurple
                                : MyColors.secondaryColor.withOpacity(0.69),
                          ),
                          Text("Ombor",
                              style: MyDecoration.textStyle.copyWith(
                                  color: widget.uiIndex == 1
                                      ? Colors.deepPurple
                                      : MyColors.secondaryColor.withOpacity(0.69),
                                  fontSize: 15,
                                  fontWeight: widget.uiIndex == 1 ? FontWeight.w600 : FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.uiIndex != 4) {
                        HapticFeedback.lightImpact();
                        SystemSound.play(SystemSoundType.click);
                        widget.changeUI(4);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 39,
                            color: widget.uiIndex == 4
                                ? Colors.deepPurple
                                : MyColors.secondaryColor.withOpacity(0.69),
                          ),
                          Text("Reja",
                              style: MyDecoration.textStyle.copyWith(
                                  color: widget.uiIndex == 4
                                      ? Colors.deepPurple
                                      : MyColors.secondaryColor.withOpacity(0.69),
                                  fontSize: 15,
                                  fontWeight: widget.uiIndex == 4 ? FontWeight.w600 : FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.uiIndex != 2) {
                        HapticFeedback.lightImpact();
                        SystemSound.play(SystemSoundType.click);
                        widget.changeUI(2);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Badge(
                            label: const Text("2"),
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 39,
                              color: widget.uiIndex == 2
                                  ? Colors.deepPurple
                                  : MyColors.secondaryColor.withOpacity(0.69),
                            ),
                          ),
                          Text("Fond",
                              style: MyDecoration.textStyle.copyWith(
                                  color: widget.uiIndex == 2
                                      ? Colors.deepPurple
                                      : MyColors.secondaryColor.withOpacity(0.69),
                                  fontSize: 15,
                                  fontWeight: widget.uiIndex == 2 ? FontWeight.w600 : FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.uiIndex != 3) {
                        HapticFeedback.lightImpact();
                        SystemSound.play(SystemSoundType.click);
                        widget.changeUI(3);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 39,
                            color: widget.uiIndex == 3
                                ? Colors.deepPurple
                                : MyColors.secondaryColor.withOpacity(0.69),
                          ),
                          Text("Shaxsiy",
                              style: MyDecoration.textStyle.copyWith(
                                  color: widget.uiIndex == 3
                                      ? Colors.deepPurple
                                      : MyColors.secondaryColor.withOpacity(0.69),
                                  fontSize: 15,
                                  fontWeight: widget.uiIndex == 3 ? FontWeight.w600 : FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
