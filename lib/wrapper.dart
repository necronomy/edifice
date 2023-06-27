import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybuilding/auth/login.dart';
import 'package:mybuilding/auth/register.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/auth/adminemptyscreen.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/adminhome.dart';
import 'package:mybuilding/auth/userwaiting.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String obyektKey = '';
  changeObyekt(String key) {
    setState(() {
      obyektKey = key;
    });
  }

  bool isReg = false;
  changeIsReg() {
    setState(() {
      isReg = !isReg;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyUser? user = Provider.of(context);
    if (user == null) {
      return isReg ? Register(changeIsReg: changeIsReg) : Login(changeIsReg: changeIsReg);
    } else {
      FirebaseMessaging.instance.subscribeToTopic(user.uid);
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("allusers").doc(user.uid).snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              UserModel userModel = UserModel.fromDocument(snapshot.data!.data()!);

              return userModel.firmauid == ''
                  //usercomfirm
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('maindatabase').doc('firmalar').snapshots(),
                      builder: ((context, firmalarsnapshots) {
                        if (firmalarsnapshots.hasData) {
                          List<FirmaModel> firmalar = [];
                          for (Map<String, dynamic> item in firmalarsnapshots.data!.data()!.values) {
                            FirmaModel firma = FirmaModel.fromDocument(item);
                            firmalar.add(firma);
                          }

                          return AdminEmptyScreen(
                            userModel: userModel,
                            firmalar: firmalar,
                          );
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
                      }))
                  : userModel.firmauid == 'waiting'
                      //userwaiting
                      ? UserWaiting(userModel: userModel)
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("maindatabase").doc('firmalar').snapshots(),
                          builder: ((context, firmasnapshots) {
                            if (firmasnapshots.hasData) {
                              FirmaModel firmaModel = FirmaModel.fromDocument(firmasnapshots.data!.data()![userModel.firmauid]);

                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('xabarlar').doc(firmaModel.xabarlar).snapshots(),
                                  builder: ((context, xabarlarsnapshots) {
                                    if (xabarlarsnapshots.hasData) {
                                      Map<String, FirmaXabarlar> firmaxabarlar = {};
                                      for (var item in xabarlarsnapshots.data!.data()!.keys) {
                                        FirmaXabarlar xabar = FirmaXabarlar.fromMap(xabarlarsnapshots.data!.data()![item]!);
                                        firmaxabarlar[item] = xabar;
                                      }
                                      if (userModel.type == "director") {
                                        if (firmaModel.obyektlar.isEmpty) {
                                          return AdminHome(
                                            userModel: userModel,
                                            firmaModel: firmaModel,
                                            firmaxabarlar: firmaxabarlar,
                                          );
                                        } else {
                                          if (obyektKey == '') {
                                            obyektKey = firmaModel.obyektlar.keys.first;
                                          }
                                          ObyektModel obyektModel = ObyektModel.fromMap(firmaModel.obyektlar[obyektKey]);
                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('ishchilar').snapshots(),
                                              builder: ((context, ishchilarsnapshots) {
                                                if (ishchilarsnapshots.hasData) {
                                                  List<IshchilarModel> ishchilar = [];
                                                  ishchilarsnapshots.data!.data()!.forEach(
                                                    (key, value) {
                                                      ishchilar.add(IshchilarModel.fromMap(value));
                                                    },
                                                  );
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('wallet').snapshots(),
                                                      builder: ((context, walletsnapshots) {
                                                        if (walletsnapshots.hasData) {
                                                          List<WalletModel> orders = [];
                                                          walletsnapshots.data!.data()!.forEach(
                                                            (key, value) {
                                                              orders.add(WalletModel.fromMap(value));
                                                            },
                                                          );
                                                          orders.sort((a, b) => a.createdTime.compareTo(b.createdTime));

                                                          return StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('plan').snapshots(),
                                                              builder: ((context, plansnapshots) {
                                                                if (plansnapshots.hasData) {
                                                                  List<PlanModel> plans = [];

                                                                  plansnapshots.data!.data()!.forEach(
                                                                    (key, value) {
                                                                      plans.add(PlanModel.fromMap(value));
                                                                    },
                                                                  );
                                                                  plans.sort((a, b) => a.startTime.compareTo(b.startTime));
                                                                  return StreamBuilder(
                                                                      stream: FirebaseFirestore.instance
                                                                          .collection(obyektModel.obyektUid)
                                                                          .doc('ombor')
                                                                          .snapshots(),
                                                                      builder: ((context, omborsnapshots) {
                                                                        if (omborsnapshots.hasData) {
                                                                          Map<String, OmborModel> ombor = {};

                                                                          omborsnapshots.data!.data()!.forEach(
                                                                            (key, value) {
                                                                              OmborModel omborModel = OmborModel.fromMap(value);
                                                                              ombor[omborModel.itemUid] = omborModel;
                                                                            },
                                                                          );
                                                                          return AdminHome(
                                                                            userModel: userModel,
                                                                            firmaModel: firmaModel,
                                                                            obyektModel: obyektModel,
                                                                            firmaxabarlar: firmaxabarlar,
                                                                            ishchilar: ishchilar,
                                                                            changeObyekt: changeObyekt,
                                                                            orders: orders,
                                                                            plans: plans,
                                                                            ombor: ombor,
                                                                          );
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
                                        }
                                      } else {
                                        //ishchi
                                        if (obyektKey == '') {
                                          obyektKey = userModel.obyektlar.first;
                                        }
                                        ObyektModel obyektModel = ObyektModel.fromMap(firmaModel.obyektlar[obyektKey]);

                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('ishchilar').snapshots(),
                                            builder: ((context, ishchilarsnapshots) {
                                              if (ishchilarsnapshots.hasData) {
                                                IshchilarModel ishchi = IshchilarModel.fromMap(ishchilarsnapshots.data!.data()![userModel.uid]);

                                                return StreamBuilder(
                                                    stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('wallet').snapshots(),
                                                    builder: ((context, walletsnapshots) {
                                                      if (walletsnapshots.hasData) {
                                                        List<WalletModel> orders = [];
                                                        walletsnapshots.data!.data()!.forEach(
                                                          (key, value) {
                                                            orders.add(WalletModel.fromMap(value));
                                                          },
                                                        );
                                                        orders.sort((a, b) => a.createdTime.compareTo(b.createdTime));

                                                        return StreamBuilder(
                                                            stream: FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('plan').snapshots(),
                                                            builder: ((context, plansnapshots) {
                                                              if (plansnapshots.hasData) {
                                                                List<PlanModel> plans = [];

                                                                plansnapshots.data!.data()!.forEach(
                                                                  (key, value) {
                                                                    plans.add(PlanModel.fromMap(value));
                                                                  },
                                                                );
                                                                plans.sort((a, b) => a.startTime.compareTo(b.startTime));

                                                                return StreamBuilder(
                                                                    stream:
                                                                        FirebaseFirestore.instance.collection(obyektModel.obyektUid).doc('ombor').snapshots(),
                                                                    builder: ((context, omborsnapshots) {
                                                                      if (omborsnapshots.hasData) {
                                                                        Map<String, OmborModel> ombor = {};

                                                                        omborsnapshots.data!.data()!.forEach(
                                                                          (key, value) {
                                                                            OmborModel omborModel = OmborModel.fromMap(value);
                                                                            ombor[omborModel.itemUid] = omborModel;
                                                                          },
                                                                        );

                                                                        return AdminHome(
                                                                          userModel: userModel,
                                                                          firmaModel: firmaModel,
                                                                          obyektModel: obyektModel,
                                                                          firmaxabarlar: firmaxabarlar,
                                                                          changeObyekt: changeObyekt,
                                                                          orders: orders,
                                                                          ishchi: ishchi,
                                                                          plans: plans,
                                                                          ombor: ombor,
                                                                        );
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
                                      }
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
    }
  }
}
