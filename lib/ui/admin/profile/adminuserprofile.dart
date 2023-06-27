import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';

class AdminUserProfile extends StatefulWidget {
  const AdminUserProfile({super.key, required this.user, required this.firmaModel});
  final Map user;
  final FirmaModel firmaModel;
  @override
  State<AdminUserProfile> createState() => _AdminUserProfileState();
}

class _AdminUserProfileState extends State<AdminUserProfile> {
  String workingWith = '';
  late Map user;
  String lavozim = '';
  Map userObyektlar = {};
  Map userDomlar = {};
  List deletedFrom = [];
  bool loading = true;

  bool hideIshdanBoshatish = true;
  List lavozimlar = ['Manager', 'Accountant', 'Subcontractor', 'Foreman', 'Subforeman'];
  funcIshdanBoshatish() async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          hideIshdanBoshatish = true;
        });
      }
    });
  }

  funcGetUser() async {
    try {
      var usr = await FirebaseFirestore.instance.collection('allusers').doc(widget.user['uid']).get();
      setState(() {
        user = usr.data()!;
      });
      for (var obyektuid in user['obyektlar']) {
        FirebaseFirestore.instance.collection(obyektuid).doc('ishchilar').get().then((value) {
          Map ishchi = value.data()![user['uid']];
          setState(() {
            userObyektlar[obyektuid] = ishchi['dostup'];
            userDomlar[obyektuid] = ishchi['ishchidomlar'];
          });
        });
      }
      if (user['obyektlar'].isNotEmpty) {
        setState(() {
          workingWith = user['obyektlar'].first;
        });
      }
      if (widget.firmaModel.ishchilar.containsKey(user['uid'])) {
        setState(() {
          lavozim = widget.firmaModel.ishchilar[user['uid']]['lavozim'];
        });
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    funcIshdanBoshatish();
    funcGetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: MyColors.bgColor,
        child: loading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.deepPurple,
                  size: 99.0,
                ),
              )
            : user['firmauid'] == 'waiting' || user['firmauid'] == widget.firmaModel.firmauid
                ? Stack(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ishchi",
                                      style: MyDecoration.textStyle
                                          .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                                  hideIshdanBoshatish
                                      ? GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor: Colors.transparent,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return SafeArea(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 19),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(19),
                                                            child: BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                                                              child: Container(
                                                                  decoration:
                                                                      MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.69)),
                                                                  child: Column(
                                                                    children: [
                                                                      ...List.generate(widget.firmaModel.obyektlar.length, (index) {
                                                                        return GestureDetector(
                                                                          onTap: () {
                                                                            HapticFeedback.lightImpact();
                                                                            SystemSound.play(SystemSoundType.click);
                                                                            setState(() {
                                                                              userObyektlar[widget.firmaModel.obyektlar.values.toList()[index]['obyektuid']] =
                                                                                  {};
                                                                              for (var item in lavozimlar) {
                                                                                userObyektlar[widget.firmaModel.obyektlar.values.toList()[index]['obyektuid']]
                                                                                    [item] = false;
                                                                              }

                                                                              userObyektlar[widget.firmaModel.obyektlar.values.toList()[index]['obyektuid']]
                                                                                  [lavozim] = true;
                                                                              userDomlar[widget.firmaModel.obyektlar.values.toList()[index]['obyektuid']] = [];
                                                                            });
                                                                            if (deletedFrom
                                                                                .contains(widget.firmaModel.obyektlar.values.toList()[index]['obyektuid'])) {
                                                                              setState(() {
                                                                                deletedFrom
                                                                                    .remove(widget.firmaModel.obyektlar.values.toList()[index]['obyektuid']);
                                                                              });
                                                                            }

                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                height: 59,
                                                                                color: Colors.transparent,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    widget.firmaModel.obyektlar.values.toList()[index]['obyektnomi'],
                                                                                    style: MyDecoration.textStyle,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Divider(
                                                                                height: 1,
                                                                                thickness: 0.5,
                                                                                color: MyColors.whiteColor.withOpacity(0.19),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                                    ],
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text("Obyekt qo'shish",
                                                style: MyDecoration.textStyle
                                                    .copyWith(color: MyColors.blueColor.withOpacity(0.79), fontSize: 17, fontWeight: FontWeight.w500)),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text("Ishdan bo'shatish",
                                              style: MyDecoration.textStyle
                                                  .copyWith(color: Colors.red.withOpacity(0.99), fontSize: 17, fontWeight: FontWeight.normal)),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 9),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(19),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19, tileMode: TileMode.repeated),
                                                  child: Container(
                                                      decoration: MyDecoration.boxDecoration.copyWith(color: MyColors.secondaryColor.withOpacity(0.49)),
                                                      child: Column(
                                                        children: [
                                                          ...List.generate(lavozimlar.length, (index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                HapticFeedback.lightImpact();
                                                                SystemSound.play(SystemSoundType.click);
                                                                setState(() {
                                                                  lavozim = lavozimlar[index];
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 49,
                                                                    color: Colors.transparent,
                                                                    child: Center(
                                                                      child: Text(
                                                                        lavozimlar[index],
                                                                        style: MyDecoration.textStyle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    height: 1,
                                                                    thickness: 0.5,
                                                                    color: MyColors.whiteColor.withOpacity(0.19),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          })
                                                        ],
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
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
                                            child: Container(
                                              height: 39,
                                              width: 39,
                                              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                              decoration: MyDecoration.circularBoxDecoration.copyWith(color: Colors.deepPurple),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: MyColors.whiteColor.withOpacity(0.99),
                                                ),
                                              ),
                                            )),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(user['name'],
                                                style: MyDecoration.textStyle.copyWith(
                                                    color: MyColors.secondaryColor.withOpacity(0.99), height: 1, fontSize: 22, fontWeight: FontWeight.w600)),
                                            Text(lavozim,
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
                            const SizedBox(
                              height: 19,
                            ),
                            ...List.generate(
                                userObyektlar.length,
                                (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                                      width: double.maxFinite,
                                      decoration: MyDecoration.boxDecoration,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (workingWith == userObyektlar.keys.toList()[index]) {
                                                setState(() {
                                                  workingWith = '';
                                                });
                                              } else {
                                                setState(() {
                                                  workingWith = userObyektlar.keys.toList()[index];
                                                });
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      workingWith != '' && workingWith == userObyektlar.keys.toList()[index]
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (!(deletedFrom.contains(userObyektlar.keys.toList()[index]))) {
                                                                    deletedFrom.add(userObyektlar.keys.toList()[index]);
                                                                  }
                                                                  userDomlar.remove(userObyektlar.keys.toList()[index]);
                                                                  userObyektlar.remove(userObyektlar.keys.toList()[index]);
                                                                });
                                                              },
                                                              child: Container(
                                                                margin: const EdgeInsets.only(right: 9),
                                                                height: 24,
                                                                width: 24,
                                                                decoration: MyDecoration.circularBoxDecoration.copyWith(color: Colors.red),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.remove_rounded,
                                                                    color: MyColors.whiteColor.withOpacity(0.99),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(
                                                              width: 7,
                                                            ),
                                                      Text(widget.firmaModel.obyektlar[userObyektlar.keys.toList()[index]]['obyektnomi'],
                                                          style: MyDecoration.textStyle.copyWith(
                                                              color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 24, fontWeight: FontWeight.w700)),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: RotatedBox(
                                                      quarterTurns: workingWith != '' && workingWith == userObyektlar.keys.toList()[index] ? 3 : 1,
                                                      child: Icon(
                                                        Icons.keyboard_arrow_right_rounded,
                                                        color: MyColors.secondaryColor.withOpacity(0.59),
                                                        size: 27,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          workingWith != '' && workingWith == userObyektlar.keys.toList()[index]
                                              ? Column(
                                                  children: [
                                                    Divider(
                                                      height: 1,
                                                      indent: 0,
                                                      thickness: 0.5,
                                                      color: MyColors.secondaryColor.withOpacity(0.19),
                                                    ),
                                                    ...List.generate(lavozimlar.length, (ind) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 9,
                                                                    width: 9,
                                                                    margin: const EdgeInsets.symmetric(horizontal: 22),
                                                                    decoration: MyDecoration.circularBoxDecoration
                                                                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.59)),
                                                                  ),
                                                                  Text(
                                                                    lavozimlar[ind],
                                                                    style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 19),
                                                                  ),
                                                                ],
                                                              ),
                                                              Switch.adaptive(
                                                                  value: userObyektlar.values.toList()[index][lavozimlar[ind]],
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      userObyektlar.values.toList()[index][lavozimlar[ind]] = value;
                                                                    });
                                                                  })
                                                            ],
                                                          ),
                                                          lavozimlar.length == ind + 1
                                                              ? const SizedBox()
                                                              : Divider(
                                                                  height: 1,
                                                                  indent: 55,
                                                                  thickness: 0.5,
                                                                  color: MyColors.secondaryColor.withOpacity(0.19),
                                                                ),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    )),
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
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                //updatefirm
                                Map ishchilar = widget.firmaModel.ishchilar;
                                ishchilar[widget.user['uid']] = {'lavozim': lavozim, 'name': widget.user['name'], 'uid': widget.user['uid']};
                                Map newFirma = {
                                  'firmauid': widget.firmaModel.firmauid,
                                  'firmanomi': widget.firmaModel.firmanomi,
                                  'firmainn': widget.firmaModel.firmainn,
                                  'director': widget.firmaModel.director,
                                  'obyektlar': widget.firmaModel.obyektlar,
                                  'payment': widget.firmaModel.payment,
                                  'ishchilar': ishchilar,
                                  'xabarlar': widget.firmaModel.xabarlar,
                                  'wallet': widget.firmaModel.wallet,
                                  'logoUrl': widget.firmaModel.logoUrl
                                };

                                await FirebaseFirestore.instance.collection('maindatabase').doc('firmalar').update({widget.firmaModel.firmauid: newFirma});

                                //updateuser

                                await FirebaseFirestore.instance.collection('allusers').doc(widget.user['uid']).update({
                                  'obyektlar': userObyektlar.keys.toList(),
                                  'firmauid': user['firmauid'] == 'waiting' ? widget.firmaModel.firmauid : user['firmauid'],
                                  'type': user['type'] == 'director' ? 'ishchi' : user['type']
                                });

                                //updateobyekt
                                for (String key in userObyektlar.keys) {
                                  FirebaseFirestore.instance.collection(key).doc('ishchilar').update({
                                    widget.user['uid']: {
                                      'ishchiuid': widget.user['uid'],
                                      'ishchinomi': widget.user['name'],
                                      'ishchidomlar': userDomlar[key],
                                      'dostup': userObyektlar[key]
                                    }
                                  });
                                }
                                if (deletedFrom.isNotEmpty) {
                                  for (String key in deletedFrom) {
                                    FirebaseFirestore.instance.collection(key).doc('ishchilar').update({widget.user['uid']: FieldValue.delete()});
                                  }
                                }

                                setState(() {
                                  loading = false;
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  height: MediaQuery.of(context).viewPadding.bottom > 19 ? 32 + MediaQuery.of(context).viewPadding.bottom : 49,
                                  width: double.maxFinite,
                                  decoration: MyDecoration.boxDecoration
                                      .copyWith(borderRadius: const BorderRadius.vertical(top: Radius.circular(0)), color: MyColors.bgColor.withOpacity(0.59)),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text("Saqlash", style: MyDecoration.textStyle.copyWith(color: Colors.deepPurple, fontSize: 19)),
                                  )),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text("Ishchi boshqa firmada ishlaydi",
                        textAlign: TextAlign.center,
                        style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 22, fontWeight: FontWeight.w400)),
                  ));
  }
}
