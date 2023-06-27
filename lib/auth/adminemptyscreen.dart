import 'package:flutter/material.dart';
import 'package:mybuilding/auth/auth.dart';
import 'package:mybuilding/auth/firmareg.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/auth/searchfirm.dart';

class AdminEmptyScreen extends StatefulWidget {
  const AdminEmptyScreen({super.key, required this.userModel, required this.firmalar});
  final UserModel userModel;
  final List<FirmaModel> firmalar;
  @override
  State<AdminEmptyScreen> createState() => _AdminEmptyScreenState();
}

class _AdminEmptyScreenState extends State<AdminEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: Stack(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myLogo(),
                const SizedBox(
                  width: 12,
                ),
                GradientText(
                  "EDIFICE",
                  gradient: const LinearGradient(colors: [
                    Colors.deepPurple,
                    Color.fromARGB(255, 32, 24, 112),
                  ]),
                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor, borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: widget.userModel.name,
                                style: MyDecoration.textStyle.copyWith(height: 1.2, color: MyColors.whiteColor, fontSize: 24, fontWeight: FontWeight.w700),
                                children: [
                                  TextSpan(
                                      text: " ishchi sifatida firmaga kiring yoki yangi firmani ro'yxatdan o'tkazing",
                                      style: MyDecoration.textStyle
                                          .copyWith(height: 1.2, color: MyColors.whiteColor.withOpacity(0.59), fontSize: 19, fontWeight: FontWeight.w300)),
                                ])),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: MyColors.whiteColor.withOpacity(0.19),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return FirmaReg(
                              userModel: widget.userModel,
                            );
                          }));
                        },
                        child: Container(
                            height: 59,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(left: 12),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Firmani ro'yxatdan o'tkazish",
                                    textAlign: TextAlign.center, style: MyDecoration.textStyle.copyWith(color: MyColors.whiteColor.withOpacity(0.89))),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: MyColors.whiteColor.withOpacity(0.29),
                                    size: 27,
                                  ),
                                )
                              ],
                            ))),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: MyColors.whiteColor.withOpacity(0.19),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return SearchFirm(
                              userModel: widget.userModel,
                              firmalar: widget.firmalar,
                            );
                          }));
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            height: 59,
                            color: Colors.transparent,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Firmaga kirish",
                                    textAlign: TextAlign.center, style: MyDecoration.textStyle.copyWith(color: MyColors.whiteColor.withOpacity(0.89))),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: MyColors.whiteColor.withOpacity(0.29),
                                    size: 27,
                                  ),
                                )
                              ],
                            ))),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: MyColors.whiteColor.withOpacity(0.19),
                      ),
                      GestureDetector(
                        onTap: () {
                          AuthService().signOut();
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 19),
                            height: 59,
                            child: Center(
                                child: Text("Profildan chiqish", textAlign: TextAlign.center, style: MyDecoration.textStyle.copyWith(color: Colors.red)))),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
