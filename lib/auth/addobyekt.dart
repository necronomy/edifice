import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/usermodel.dart';

class AddObyekt extends StatefulWidget {
  const AddObyekt({super.key, required this.usermodel, required this.firmaModel});
  final UserModel usermodel;
  final FirmaModel firmaModel;
  @override
  State<AddObyekt> createState() => _AddObyektState();
}

class _AddObyektState extends State<AddObyekt> {
  final ImagePicker picker = ImagePicker();
  String obyektNomi = '';
  File? fileImage;
  bool loading = false;
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
            : SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Obyekt qo'shish",
                            textAlign: TextAlign.center,
                            style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 29, fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.all(19),
                          decoration: MyDecoration.boxDecoration,
                          width: double.maxFinite,
                          margin: const EdgeInsets.all(19).copyWith(bottom: 9, top: 29),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    setState(() {
                                      fileImage = File(image.path);
                                    });
                                  }
                                },
                                child: fileImage == null
                                    ? DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(59),
                                        padding: const EdgeInsets.all(6),
                                        color: MyColors.secondaryColor,
                                        strokeWidth: 1.2,
                                        child: Container(
                                          height: 79,
                                          width: 79,
                                          decoration: MyDecoration.circularBoxDecoration.copyWith(color: MyColors.bgColor),
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_rounded,
                                              color: MyColors.secondaryColor,
                                            ),
                                          ),
                                        ))
                                    : Container(
                                        height: 79,
                                        width: 79,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: const [BoxShadow(color: MyColors.bgColor, blurRadius: 9, spreadRadius: 3)],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: FileImage(fileImage!), fit: BoxFit.cover)),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text("Obyekt logosi",
                                    style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 15, fontWeight: FontWeight.w300)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        obyektNomi = value;
                                      });
                                    },
                                    style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17),
                                    decoration: MyDecoration.inputDecoration.copyWith(labelText: "Obyekt nomi")),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                int rand = Random().nextInt(99999) + 100000;
                                String imageUID = "logo$rand";
                                String obyektUID = "obyekt$rand";
                                await FirebaseStorage.instance.ref("obyektlogos/$imageUID").putFile(fileImage!);

                                // await FirebaseFirestore.instance.collection('maindatabase').doc('firmalar').update({
                                //   firmaUID: {
                                //     'firmauid': firmaUID,
                                //     'firmanomi': firmanomi,
                                //     'firmainn': firmainn,
                                //     'director': widget.userModel.uid,
                                //     'obyektlar': {},
                                //     'payment': {},
                                //     'ishchilar': {},
                                //     'xabarlar': {},
                                //     'wallet': {},
                                //     'logoUrl': imageUID
                                //   }
                                // });
                                await FirebaseFirestore.instance.collection(obyektUID).doc('ishchilar').set({});
                                await FirebaseFirestore.instance.collection(obyektUID).doc('ombor').set({});
                                await FirebaseFirestore.instance.collection(obyektUID).doc('plan').set({});
                                await FirebaseFirestore.instance.collection(obyektUID).doc('wallet').set({});
                                await FirebaseFirestore.instance.collection(obyektUID).doc('xabarlar').set({});
                                await FirebaseFirestore.instance.collection(obyektUID).doc('domlar').set({
                                  "dom0": {
                                    'domname': 'Bino 1',
                                    'dometaj': '1 etaj',
                                    'domxonadonlar': '1 ta',
                                    'dompodyezd': '1 ta',
                                  }
                                });

                                Map obyektlar = widget.firmaModel.obyektlar;
                                obyektlar[obyektUID] = {'obyektuid': obyektUID, 'obyektnomi': obyektNomi, 'obyektImageUrl': imageUID};

                                await FirebaseFirestore.instance.collection('maindatabase').doc('firmalar').update({
                                  widget.firmaModel.firmauid: {
                                    'firmauid': widget.firmaModel.firmauid,
                                    'firmanomi': widget.firmaModel.firmanomi,
                                    'firmainn': widget.firmaModel.firmainn,
                                    'director': widget.firmaModel.director,
                                    'obyektlar': obyektlar,
                                    'payment': widget.firmaModel.payment,
                                    'ishchilar': widget.firmaModel.ishchilar,
                                    'xabarlar': widget.firmaModel.xabarlar,
                                    'wallet': widget.firmaModel.wallet,
                                    'logoUrl': widget.firmaModel.logoUrl
                                  }
                                });

                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: const Text("Obyektni qo'shish", style: MyDecoration.textStyle)),
                        )),
                  ],
                ),
              ));
  }
}
