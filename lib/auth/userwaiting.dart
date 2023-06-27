import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/auth/auth.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/usermodel.dart';

class UserWaiting extends StatefulWidget {
  const UserWaiting({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<UserWaiting> createState() => _UserWaitingState();
}

class _UserWaitingState extends State<UserWaiting> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: SafeArea(
        child: Stack(
          children: [
            Row(
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
            Center(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: widget.userModel.name,
                      style: MyDecoration.textStyle.copyWith(height: 1.2, color: Colors.deepPurple, fontSize: 24, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: " firma sizni ishga qabul qilishini kuting...",
                            style: MyDecoration.textStyle
                                .copyWith(height: 1.2, color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 19, fontWeight: FontWeight.w300)),
                      ])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: myButton(
                  function: () {
                    FirebaseFirestore.instance.collection('allusers').doc(widget.userModel.uid).update({'firmauid': ''});
                  },
                  child:
                      Text("Bekor qilish", textAlign: TextAlign.center, style: MyDecoration.textStyle.copyWith(color: MyColors.whiteColor.withOpacity(0.89))),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    AuthService().signOut();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 29,
                      color: Color.fromARGB(255, 224, 15, 0),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
