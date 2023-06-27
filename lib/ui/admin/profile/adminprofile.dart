import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/auth/addobyekt.dart';
import 'package:mybuilding/auth/auth.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybuilding/ui/admin/profile/adminsettings.dart';
import 'package:mybuilding/ui/admin/profile/adminusers.dart';
import 'package:mybuilding/ui/admin/profile/obyekt.dart';
import 'package:mybuilding/ui/uskunavamahsulotlar.dart';

class AdminPersonal extends StatefulWidget {
  const AdminPersonal({super.key, required this.userModel, required this.firmaModel, required this.ishchilar});
  final UserModel userModel;
  final FirmaModel firmaModel;

  final List<IshchilarModel> ishchilar;
  @override
  State<AdminPersonal> createState() => _AdminPersonalState();
}

class _AdminPersonalState extends State<AdminPersonal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0, left: 19, right: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'shaxsiy',
                  child: Material(
                    color: Colors.transparent,
                    child: Text("Shaxsiy",
                        style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseMessaging.instance.unsubscribeFromTopic(widget.userModel.uid);
                    AuthService().signOut();
                  },
                  child: Icon(
                    Icons.logout_rounded,
                    color: MyColors.secondaryColor.withOpacity(0.69),
                    size: 35,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AdminSettings();
              }));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
              width: double.maxFinite,
              decoration: MyDecoration.boxDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        child: CircleAvatar(
                          radius: 29,
                          backgroundImage: NetworkImage(
                            logoImageUrl(widget.firmaModel.logoUrl),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.firmaModel.firmanomi,
                              style: MyDecoration.textStyle
                                  .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 22, fontWeight: FontWeight.w600)),
                          Text(widget.userModel.name,
                              style: MyDecoration.textStyle
                                  .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 15, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: MyColors.secondaryColor.withOpacity(0.29),
                      size: 27,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
            width: double.maxFinite,
            decoration: MyDecoration.boxDecoration,
            child: Column(
              children: [
                isoItem(iconColor: Colors.green, iconData: Icons.payment_rounded, txt: "To'lovlar", lastText: ''),
                Divider(
                  height: 1,
                  indent: 55,
                  thickness: 0.5,
                  color: MyColors.secondaryColor.withOpacity(0.19),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AdminUsers(
                          firmaModel: widget.firmaModel,
                          ishchilar: widget.ishchilar,
                        );
                      }));
                    },
                    child: isoItem(
                        iconColor: Colors.orange, iconData: Icons.people_alt_rounded, txt: 'Ishchilar', lastText: '${widget.firmaModel.ishchilar.length} ta')),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
            width: double.maxFinite,
            decoration: MyDecoration.boxDecoration,
            child: Column(
              children: [
                ...List.generate(widget.firmaModel.obyektlar.values.toList().length, (index) {
                  return widget.userModel.type == 'director' || widget.userModel.obyektlar.contains(widget.firmaModel.obyektlar.keys.toList()[index])
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ObyektModel obyektModel = ObyektModel.fromMap(widget.firmaModel.obyektlar.values.toList()[index]);
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Obyekt(
                                    firmaModel: widget.firmaModel,
                                    userModel: widget.userModel,
                                    obyektModel: obyektModel,
                                  );
                                }));
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 39,
                                          height: 39,
                                          margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                          decoration: MyDecoration.boxDecoration.copyWith(
                                              boxShadow: [BoxShadow(color: MyColors.secondaryColor.withOpacity(0.19), blurRadius: 9, spreadRadius: 0)],
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(obyektLogoImageUrl(widget.firmaModel.obyektlar.values.toList()[index]['obyektImageUrl'])),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Text(widget.firmaModel.obyektlar.values.toList()[index]['obyektnomi'],
                                            style: MyDecoration.textStyle
                                                .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 21, fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: MyColors.secondaryColor.withOpacity(0.29),
                                      size: 27,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              indent: 59,
                              thickness: 0.5,
                              color: MyColors.secondaryColor.withOpacity(0.19),
                            ),
                          ],
                        )
                      : const SizedBox();
                }),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return AddObyekt(
                        usermodel: widget.userModel,
                        firmaModel: widget.firmaModel,
                      );
                    }));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 39,
                              height: 39,
                              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                              decoration: MyDecoration.boxDecoration.copyWith(
                                color: MyColors.blueColor.withOpacity(0.79),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_rounded,
                                  color: MyColors.whiteColor,
                                ),
                              ),
                            ),
                            Text("Obyekt yaratish",
                                style:
                                    MyDecoration.textStyle.copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 21, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: MyColors.secondaryColor.withOpacity(0.29),
                          size: 27,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
            width: double.maxFinite,
            decoration: MyDecoration.boxDecoration,
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('maindatabase').doc('uskunavamahsulot').snapshots(),
                            builder: ((context, uskunavamahsulotlarsnapshots) {
                              if (uskunavamahsulotlarsnapshots.hasData) {
                                Map? uskunavamahsulotlar = uskunavamahsulotlarsnapshots.data!.data();

                                return UskunaVaMahsulotlar(uskunavamahsulotlar: uskunavamahsulotlar ?? {});
                              } else {
                                return const Material(
                                  color: MyColors.bgColor,
                                  child: Center(
                                    child: SpinKitSpinningLines(
                                      color: Colors.deepPurple,
                                      size: 99.0,
                                    ),
                                  ),
                                );
                              }
                            }));
                      }));
                    },
                    child: isoItem(iconColor: Colors.deepPurple, iconData: Icons.list_rounded, txt: 'Uskuna va mahsulotlar', lastText: '')),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + 69,
          ),
        ],
      ),
    );
  }
}

Widget isoItem({required Color iconColor, required IconData iconData, required String txt, required String lastText}) {
  return Container(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              padding: const EdgeInsets.all(3),
              decoration: MyDecoration.boxDecoration.copyWith(color: iconColor, borderRadius: BorderRadius.circular(9)),
              child: Center(
                child: Icon(
                  iconData,
                  color: MyColors.whiteColor,
                ),
              ),
            ),
            Text(txt, style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 21, fontWeight: FontWeight.normal)),
          ],
        ),
        Row(
          children: [
            Text(lastText,
                style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 18, fontWeight: FontWeight.w500)),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: MyColors.secondaryColor.withOpacity(0.29),
              size: 27,
            ),
          ],
        )
      ],
    ),
  );
}
