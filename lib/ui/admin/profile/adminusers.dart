import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/ui/admin/admintop.dart';
import 'package:mybuilding/ui/admin/profile/adminuserprofile.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key, required this.firmaModel, required this.ishchilar});
  final FirmaModel firmaModel;
  final List<IshchilarModel> ishchilar;

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.bgColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19.0, left: 19, right: 19, bottom: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text("Ishchilar",
                                style: MyDecoration.textStyle
                                    .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                    widget.firmaModel.ishchilar.length,
                    (index) => GestureDetector(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AdminUserProfile(
                                firmaModel: widget.firmaModel,
                                user: {
                                  'name': widget.firmaModel.ishchilar.values.toList()[index]['name'],
                                  'uid': widget.firmaModel.ishchilar.values.toList()[index]['uid']
                                },
                              );
                            }));
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 19).copyWith(bottom: 9),
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            decoration: MyDecoration.boxDecoration,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: MyColors.secondaryColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: MyColors.whiteColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    widget.firmaModel.ishchilar.values.toList()[index]['name'],
                                    style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.firmaModel.ishchilar.values.toList()[index]['lavozim'],
                                    style: MyDecoration.textStyle.copyWith(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.w400),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ))
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: AdminTop(),
          ),
        ],
      ),
    );
  }
}
