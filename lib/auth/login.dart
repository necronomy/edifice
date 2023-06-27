import 'package:flutter/material.dart';
import 'package:mybuilding/auth/auth.dart';

import 'package:mybuilding/const.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.changeIsReg});
  final Function changeIsReg;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String tel = '';
  String password = '';
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 39, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(19),
                    decoration: MyDecoration.boxDecoration,
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(19).copyWith(bottom: 9, top: 29),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Kirish", style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 27, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  tel = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17),
                              decoration: MyDecoration.inputDecoration.copyWith(labelText: "Telefon nomer", prefixText: '+998 ')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17),
                              decoration: MyDecoration.inputDecoration.copyWith(labelText: "Ka'lit so'z")),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Profil bo'lmasa: ",
                          style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17, fontWeight: FontWeight.normal)),
                      GestureDetector(
                          onTap: () {
                            widget.changeIsReg();
                          },
                          child: Text("Ro'yxatdan o'tish",
                              style: MyDecoration.textStyle.copyWith(color: MyColors.blueColor, fontSize: 17, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: myButton(
                      function: () async {
                        setState(() {
                          loading = true;
                        });
                        await AuthService().signInWithEmailAndPassword(login: tel, password: password);
                      },
                      child: const Text("Kirish", style: MyDecoration.textStyle)),
                )),
          ],
        ),
      ),
    );
  }
}
