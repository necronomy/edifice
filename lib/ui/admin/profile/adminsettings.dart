import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: MyColors.bgColor,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 39,
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: MyColors.blueColor,
                          ),
                          Hero(
                            tag: 'shaxsiy',
                            child: Material(
                              color: Colors.transparent,
                              child: Text("Shaxsiy",
                                  style: MyDecoration.textStyle.copyWith(
                                      color: MyColors.blueColor.withOpacity(0.99),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text("Settings",
                          style: MyDecoration.textStyle.copyWith(
                              color: MyColors.secondaryColor.withOpacity(0.99),
                              fontSize: 19,
                              fontWeight: FontWeight.w700)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
