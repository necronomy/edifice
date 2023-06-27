import 'dart:io';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:mybuilding/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybuilding/models/usermodel.dart';

class FirmaReg extends StatefulWidget {
  const FirmaReg({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<FirmaReg> createState() => _FirmaRegState();
}

class _FirmaRegState extends State<FirmaReg> {
  final ImagePicker picker = ImagePicker();
  File? fileImage;
  String firmanomi = '';
  String firmainn = '';
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
                      Text("Firmani ro'yxatdan o'tkazish",
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
                              child: Text("Firma logosi",
                                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 15, fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      firmanomi = value;
                                    });
                                  },
                                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17),
                                  decoration: MyDecoration.inputDecoration.copyWith(labelText: "Firma nomi")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      firmainn = value;
                                    });
                                  },
                                  style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontSize: 17),
                                  decoration: MyDecoration.inputDecoration.copyWith(labelText: "Firma INN")),
                            )
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
                              String firmaUID = "firma$rand";
                              String xabarlarUID = 'xabarlar$rand';
                              await FirebaseStorage.instance.ref("logos/$imageUID").putFile(fileImage!);
                              await FirebaseFirestore.instance.collection('xabarlar').doc(xabarlarUID).set({});
                              await FirebaseFirestore.instance.collection('maindatabase').doc('firmalar').update({
                                firmaUID: {
                                  'firmauid': firmaUID,
                                  'firmanomi': firmanomi,
                                  'firmainn': firmainn,
                                  'director': widget.userModel.uid,
                                  'obyektlar': {},
                                  'payment': {},
                                  'ishchilar': {},
                                  'xabarlar': xabarlarUID,
                                  'wallet': {},
                                  'logoUrl': imageUID
                                }
                              });

                              FirebaseFirestore.instance.collection('allusers').doc(widget.userModel.uid).update({'firmauid': firmaUID});
                              setState(() {
                                loading = false;
                              });
                            },
                            child: const Text("Ro'yxatdan o'kazish", style: MyDecoration.textStyle)),
                      )),
                ],
              ),
            ),
    );
  }
}
