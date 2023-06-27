import 'package:flutter/material.dart';
import 'package:mybuilding/const.dart';
import 'package:mybuilding/models/firmamodel.dart';
import 'package:mybuilding/models/obyektmodel.dart';
import 'package:mybuilding/models/usermodel.dart';
import 'package:mybuilding/ui/admin/plan/showplanfull.dart';
import 'package:mybuilding/ui/admin/selectdom.dart';

class AdminPlan extends StatefulWidget {
  const AdminPlan(
      {super.key,
      required this.userModel,
      required this.domlar,
      required this.changeDom,
      required this.domKey,
      required this.plans,
      this.ishchi,
      required this.firmaModel,
      required this.obyektModel});
  final UserModel userModel;
  final Map domlar;
  final String domKey;
  final Function changeDom;
  final FirmaModel firmaModel;
  final ObyektModel obyektModel;
  final List<PlanModel> plans;
  final IshchilarModel? ishchi;
  @override
  State<AdminPlan> createState() => _AdminPlanState();
}

class _AdminPlanState extends State<AdminPlan> {
  Color clr = MyColors.secondaryColor.withOpacity(0.89);
  Color deepPurple = Colors.deepPurple;

  int curStep = -1;
  int endedStep = -1;

  @override
  void initState() {
    super.initState();
    for (PlanModel planModel in widget.plans) {
      if (planModel.startTimeRealString.isNotEmpty) {
        endedStep = widget.plans.indexOf(planModel);
        curStep = widget.plans.indexOf(planModel);
      }
      if (planModel.endTimeRealString.isNotEmpty) {
        endedStep = widget.plans.indexOf(planModel) + 1;
        curStep = widget.plans.indexOf(planModel) + 1;
      }
    }
  }

  @override
  void didUpdateWidget(covariant AdminPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    curStep = -1;
    endedStep = -1;
    for (PlanModel planModel in widget.plans) {
      if (planModel.startTimeRealString.isNotEmpty) {
        endedStep = widget.plans.indexOf(planModel);
        curStep = widget.plans.indexOf(planModel);
      }
      if (planModel.endTimeRealString.isNotEmpty) {
        endedStep = widget.plans.indexOf(planModel) + 1;
        curStep = widget.plans.indexOf(planModel) + 1;
      }
    }
  }

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
            padding: const EdgeInsets.only(top: 19.0, left: 19, right: 9, bottom: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("THURSDAY 25 MAY",
                    style: MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.59), fontSize: 14, fontWeight: FontWeight.w600)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text("Reja",
                              style: MyDecoration.textStyle
                                  .copyWith(color: MyColors.secondaryColor.withOpacity(0.99), fontSize: 37, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    widget.domlar.isEmpty
                        ? Text('Binolar mavjud emas',
                            style:
                                MyDecoration.textStyle.copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 19, fontWeight: FontWeight.w700))
                        : GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  enableDrag: false,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return SelectDom(
                                      domKey: widget.domKey,
                                      changeDom: widget.changeDom,
                                      domlar: widget.domlar,
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Text(widget.domlar[widget.domKey]['domname'],
                                    style: MyDecoration.textStyle
                                        .copyWith(color: MyColors.secondaryColor.withOpacity(0.49), fontSize: 24, fontWeight: FontWeight.w700)),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: MyColors.secondaryColor.withOpacity(0.49),
                                    size: 29,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 99,
                child: Column(
                  children: [
                    ...List.generate(widget.plans.length, (index) {
                      return Column(
                        children: [
                          AnimatedContainer(
                            height: index == curStep ? 59 : 39,
                            width: index == curStep ? 59 : 39,
                            duration: const Duration(milliseconds: 200),
                            decoration: MyDecoration.circularBoxDecoration
                                .copyWith(color: endedStep >= index ? deepPurple : MyColors.secondaryColor.withOpacity(0.39)),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: MyDecoration.textStyle.copyWith(
                                  fontSize: index == curStep ? 29 : 19,
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 3,
                            height: index == curStep ? 399 : 39,
                            decoration: MyDecoration.boxDecoration.copyWith(
                              borderRadius: BorderRadius.zero,
                              gradient: LinearGradient(colors: [
                                ...List.generate(
                                  30,
                                  (ind) => endedStep >= index ? deepPurple : MyColors.secondaryColor.withOpacity(0.39),
                                ),
                                ...List.generate(
                                  endedStep == index ? 30 : 0,
                                  (index) => MyColors.secondaryColor.withOpacity(0.39),
                                )
                              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                            ),
                          )
                        ],
                      );
                    }),
                    Column(
                      children: [
                        AnimatedContainer(
                          height: 39,
                          width: 39,
                          duration: const Duration(milliseconds: 200),
                          decoration: MyDecoration.circularBoxDecoration.copyWith(
                              color:
                                  widget.ishchi != null && widget.ishchi!.dostup['Manager'] ? MyColors.secondaryColor.withOpacity(0.89) : MyColors.bgColor2),
                          child: Center(
                            child: Icon(
                              Icons.add_rounded,
                              size: 29,
                              color: widget.ishchi != null && widget.ishchi!.dostup['Manager'] ? MyColors.whiteColor : MyColors.whiteColor.withOpacity(0.69),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 3,
                          height: 19,
                          decoration: MyDecoration.boxDecoration.copyWith(borderRadius: BorderRadius.zero, color: Colors.transparent),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      ...List.generate(widget.plans.length, (index) {
                        return MyAnimation(
                            child: Hero(
                              tag: "tag$index",
                              child: Material(
                                color: Colors.transparent,
                                child: AnimatedContainer(
                                  margin: const EdgeInsets.only(bottom: 19, right: 9),
                                  height: index == curStep ? 399 + 59 - 19 : 39 + 39 - 19,
                                  width: double.infinity,
                                  duration: const Duration(milliseconds: 200),
                                  decoration: MyDecoration.boxDecoration.copyWith(
                                      color: endedStep == index ? deepPurple : MyColors.whiteColor.withOpacity(0.99),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyColors.secondaryColor.withOpacity(endedStep == index ? 0.49 : 0.19),
                                            blurRadius: 19,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 9))
                                      ]),
                                  child: index != curStep
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 14),
                                              child: Text(
                                                widget.plans[index].planNomi,
                                                maxLines: 2,
                                                style: MyDecoration.textStyle.copyWith(
                                                    height: 1.1,
                                                    fontSize: 21,
                                                    color: endedStep == index
                                                        ? MyColors.whiteColor
                                                        : endedStep >= index
                                                            ? clr
                                                            : MyColors.secondaryColor.withOpacity(0.49),
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  child: Text(
                                                    widget.plans[index].planNomi,
                                                    maxLines: 2,
                                                    style: MyDecoration.textStyle.copyWith(
                                                        height: 1.1,
                                                        fontSize: 21,
                                                        color: endedStep == index
                                                            ? MyColors.whiteColor
                                                            : endedStep >= index
                                                                ? clr
                                                                : MyColors.secondaryColor.withOpacity(0.49),
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Boshlash Rejasi: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            widget.plans[index].startTimeString,
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 19,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.79)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.79)
                                                                        : MyColors.secondaryColor.withOpacity(0.59),
                                                                fontWeight: FontWeight.w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Tugash Rejasi: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            widget.plans[index].endTimeString,
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 19,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.79)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.79)
                                                                        : MyColors.secondaryColor.withOpacity(0.59),
                                                                fontWeight: FontWeight.w300),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                  color: endedStep == index
                                                      ? MyColors.whiteColor.withOpacity(0.19)
                                                      : endedStep >= index
                                                          ? clr.withOpacity(0.19)
                                                          : MyColors.secondaryColor.withOpacity(0.09),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Boshlandi: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            widget.plans[index].startTimeRealString.isEmpty
                                                                ? "Kutilmoqda"
                                                                : widget.plans[index].startTimeRealString,
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 19,
                                                                color: widget.plans[index].startTimeRealString.isEmpty
                                                                    ? Colors.amber
                                                                    : endedStep == index
                                                                        ? MyColors.whiteColor.withOpacity(0.79)
                                                                        : endedStep >= index
                                                                            ? clr.withOpacity(0.79)
                                                                            : MyColors.secondaryColor.withOpacity(0.59),
                                                                fontWeight: FontWeight.w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Tugadi: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            widget.plans[index].endTimeRealString.isEmpty
                                                                ? "Kutilmoqda"
                                                                : widget.plans[index].endTimeRealString,
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 19,
                                                                color: widget.plans[index].endTimeRealString.isEmpty
                                                                    ? Colors.amber
                                                                    : endedStep == index
                                                                        ? MyColors.whiteColor.withOpacity(0.79)
                                                                        : endedStep >= index
                                                                            ? clr.withOpacity(0.79)
                                                                            : MyColors.secondaryColor.withOpacity(0.59),
                                                                fontWeight: FontWeight.w300),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                  color: endedStep == index
                                                      ? MyColors.whiteColor.withOpacity(0.19)
                                                      : endedStep >= index
                                                          ? clr.withOpacity(0.19)
                                                          : MyColors.secondaryColor.withOpacity(0.09),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Ishchilar soni",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            widget.plans[index].numIshchilar,
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 22,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.89)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.79)
                                                                        : MyColors.secondaryColor.withOpacity(0.59),
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Manager: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              widget.plans[index].manager.values.toList()[0],
                                                              textAlign: TextAlign.end,
                                                              maxLines: 2,
                                                              style: MyDecoration.textStyle.copyWith(
                                                                  fontSize: 19,
                                                                  height: 1,
                                                                  color: endedStep == index
                                                                      ? MyColors.whiteColor.withOpacity(0.89)
                                                                      : endedStep >= index
                                                                          ? clr.withOpacity(0.79)
                                                                          : MyColors.secondaryColor.withOpacity(0.59),
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "SubContractor: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              widget.plans[index].subContractor.values.toList()[0],
                                                              maxLines: 2,
                                                              textAlign: TextAlign.end,
                                                              style: MyDecoration.textStyle.copyWith(
                                                                  fontSize: 19,
                                                                  height: 1,
                                                                  color: endedStep == index
                                                                      ? MyColors.whiteColor.withOpacity(0.89)
                                                                      : endedStep >= index
                                                                          ? clr.withOpacity(0.79)
                                                                          : MyColors.secondaryColor.withOpacity(0.59),
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Foreman: ",
                                                            style: MyDecoration.textStyle.copyWith(
                                                                fontSize: 16,
                                                                color: endedStep == index
                                                                    ? MyColors.whiteColor.withOpacity(0.69)
                                                                    : endedStep >= index
                                                                        ? clr.withOpacity(0.59)
                                                                        : MyColors.secondaryColor.withOpacity(0.39),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              widget.plans[index].foreman.values.toList()[0],
                                                              maxLines: 2,
                                                              textAlign: TextAlign.end,
                                                              style: MyDecoration.textStyle.copyWith(
                                                                  fontSize: 19,
                                                                  height: 1,
                                                                  color: endedStep == index
                                                                      ? MyColors.whiteColor.withOpacity(0.89)
                                                                      : endedStep >= index
                                                                          ? clr.withOpacity(0.79)
                                                                          : MyColors.secondaryColor.withOpacity(0.59),
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(context, MaterialPageRoute(builder: ((context) {
                                                  return ShowPlanFull(
                                                    userModel: widget.userModel,
                                                    domlar: widget.domlar,
                                                    changeDom: widget.changeDom,
                                                    domKey: widget.domKey,
                                                    firmaModel: widget.firmaModel,
                                                    obyektModel: widget.obyektModel,
                                                    planModel: widget.plans[index],
                                                    ishchi: widget.ishchi,
                                                    canStart: index == 0
                                                        ? widget.plans[index].startTimeRealString.isEmpty
                                                            ? true
                                                            : false
                                                        : widget.plans[index - 1].endTimeRealString.isNotEmpty &&
                                                                widget.plans[index].startTimeRealString.isEmpty
                                                            ? true
                                                            : false,
                                                    ended:
                                                        widget.plans[index].startTimeRealString.isNotEmpty && widget.plans[index].endTimeRealString.isNotEmpty,
                                                  );
                                                })));
                                                setState(() {});
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
                                                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                        color: endedStep == index
                                                            ? MyColors.whiteColor.withOpacity(0.39)
                                                            : endedStep >= index
                                                                ? clr.withOpacity(0.39)
                                                                : MyColors.secondaryColor.withOpacity(0.19),
                                                        width: 0.9)),
                                                child: Center(
                                                  child: Text("Batafsil",
                                                      style: MyDecoration.textStyle.copyWith(
                                                          height: 1,
                                                          fontSize: 21,
                                                          color: endedStep == index
                                                              ? MyColors.whiteColor
                                                              : endedStep >= index
                                                                  ? clr.withOpacity(0.99)
                                                                  : MyColors.secondaryColor.withOpacity(0.49),
                                                          fontWeight: FontWeight.w600)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            function: () {
                              if (curStep == index) {
                              } else {
                                setState(() {
                                  curStep = index;
                                });
                              }
                            });
                      }),
                      MyAnimation(
                          child: Material(
                            color: Colors.transparent,
                            child: AnimatedContainer(
                              margin: const EdgeInsets.only(bottom: 19, right: 9),
                              height: 39 + 39 - 19,
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: MyDecoration.boxDecoration.copyWith(
                                  color: widget.ishchi != null && widget.ishchi!.dostup['Manager'] ? clr : MyColors.bgColor2,
                                  boxShadow: [BoxShadow(color: MyColors.secondaryColor.withOpacity(0.29), blurRadius: 19, offset: const Offset(0, 9))]),
                              child: Row(
                                children: [
                                  Text(
                                    "Yangi Reja qo'shish",
                                    maxLines: 1,
                                    style: MyDecoration.textStyle.copyWith(
                                        height: 1,
                                        fontSize: 21,
                                        color: MyColors.whiteColor.withOpacity(widget.ishchi != null && widget.ishchi!.dostup['Manager'] ? 0.99 : 0.69),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          function: () async {
                            if (widget.ishchi != null && widget.ishchi!.dostup['Manager']) {
                              await Navigator.push(context, MaterialPageRoute(builder: ((context) {
                                return ShowPlanFull(
                                  userModel: widget.userModel,
                                  domlar: widget.domlar,
                                  changeDom: widget.changeDom,
                                  domKey: widget.domKey,
                                  firmaModel: widget.firmaModel,
                                  obyektModel: widget.obyektModel,
                                  canStart: false,
                                  ended: false,
                                  ishchi: widget.ishchi,
                                );
                              })));
                              setState(() {});
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + 69,
          ),
        ],
      ),
    );
  }
}
