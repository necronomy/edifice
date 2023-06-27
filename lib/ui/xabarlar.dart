import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';
import 'package:mybuilding/ui/admin/profile/adminuserprofile.dart';

class Xabarlar extends StatefulWidget {
  const Xabarlar(
      {super.key, required this.userModel, required this.firmaxabarlar, required this.firmaModel});
  final UserModel userModel;
  final Map<String, FirmaXabarlar> firmaxabarlar;
  final FirmaModel firmaModel;

  @override
  State<Xabarlar> createState() => _XabarlarState();
}

class _XabarlarState extends State<Xabarlar> {
  Map<String, FirmaXabarlar> firmaxabarlar = {};
  Map<String, FirmaXabarlar> activeXabarlar = {};

  directorXabarlar() {
    FirebaseFirestore.instance
        .collection('xabarlar')
        .doc(widget.firmaModel.xabarlar)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          firmaxabarlar = {};
          activeXabarlar = {};
        });
        for (var item in event.data()!.keys) {
          FirmaXabarlar xabar = FirmaXabarlar.fromMap(event.data()![item]!);
          setState(() {
            firmaxabarlar[item] = xabar;
          });
        }
        firmaxabarlar.entries.where((element) => element.value.isActive).forEach((item) {
          setState(() {
            activeXabarlar[item.key] = item.value;
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firmaxabarlar = widget.firmaxabarlar;
    widget.firmaxabarlar.entries.where((element) => element.value.isActive).forEach((item) {
      activeXabarlar[item.key] = item.value;
    });
    if (widget.userModel.type == 'director') {
      directorXabarlar();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // for (var key in widget.activeXabarlar.keys) {
    //   Map newXabar = {
    //     'isActive': false,
    //     'person': widget.activeXabarlar[key]!.person,
    //     'personuid': widget.activeXabarlar[key]!.uid,
    //     'type': widget.activeXabarlar[key]!.type,
    //   };
    //   FirebaseFirestore.instance.collection('xabarlar').doc(widget.firmaModel.xabarlar).update({key: newXabar});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: MyColors.bgColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.top,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 19.0, left: 19, right: 19),
                    child: Row(
                      children: [
                        Text("Xabarlar",
                            style: MyDecoration.textStyle.copyWith(
                                color: MyColors.secondaryColor.withOpacity(0.99),
                                fontSize: 37,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                    margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                    width: double.maxFinite,
                    decoration: MyDecoration.boxDecoration.copyWith(color: Colors.deepPurple),
                    child: ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      title: Text("To'lov",
                          style: MyDecoration.textStyle.copyWith(
                              color: MyColors.whiteColor.withOpacity(0.99),
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          "Keyingi oy uchun to'lovni amalga oshiring. UzumPay orqali 3% chegirma mavjud.",
                          style: MyDecoration.textStyle.copyWith(
                              color: MyColors.whiteColor.withOpacity(0.99),
                              height: 1,
                              fontSize: 17,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(19.0).copyWith(bottom: 1),
                    child: Row(
                      children: [
                        Text("Yangi xabarlar",
                            style: MyDecoration.textStyle.copyWith(
                                color: MyColors.secondaryColor.withOpacity(0.49),
                                fontSize: 19,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  ...List.generate(activeXabarlar.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AdminUserProfile(firmaModel: widget.firmaModel, user: {
                            'name': activeXabarlar.values.toList()[index].person,
                            'uid': activeXabarlar.values.toList()[index].uid,
                          });
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                        width: double.maxFinite,
                        decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.whiteColor),
                        child: ListTile(
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          title: Text(activeXabarlar.values.toList()[index].person,
                              style: MyDecoration.textStyle.copyWith(
                                  color: MyColors.secondaryColor.withOpacity(0.99),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                              activeXabarlar.values.toList()[index].type == 'qabul'
                                  ? 'Ishga qabul qilish'
                                  : '',
                              style: MyDecoration.textStyle.copyWith(
                                  color: MyColors.secondaryColor.withOpacity(0.99),
                                  height: 1,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),
                          trailing: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: MyColors.secondaryColor.withOpacity(0.29),
                            size: 27,
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.bottom + 69,
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: AdminTop(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        height: MediaQuery.of(context).viewPadding.bottom > 19
                            ? 32 + MediaQuery.of(context).viewPadding.bottom
                            : 49,
                        width: double.maxFinite,
                        decoration: MyDecoration.boxDecoration.copyWith(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                            color: MyColors.bgColor.withOpacity(0.59)),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text("Barcha xabarlarni ko'rsatish",
                              style:
                                  MyDecoration.textStyle.copyWith(color: Colors.deepPurple, fontSize: 17)),
                        )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
