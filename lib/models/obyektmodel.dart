import 'package:cloud_firestore/cloud_firestore.dart';

class ObyektModel {
  final String obyektUid;
  final String obyektNomi;
  final String imageUrl;
  ObyektModel({required this.obyektUid, required this.obyektNomi, required this.imageUrl});
  factory ObyektModel.fromMap(Map doc) {
    return ObyektModel(obyektUid: doc['obyektuid'], obyektNomi: doc['obyektnomi'], imageUrl: doc['obyektImageUrl']);
  }
}

class IshchilarModel {
  final String ishchinomi;
  final String ishchiuid;
  final Map dostup;
  final List ishchidomlar;
  IshchilarModel({required this.ishchinomi, required this.ishchiuid, required this.dostup, required this.ishchidomlar});
  factory IshchilarModel.fromMap(Map doc) {
    return IshchilarModel(ishchinomi: doc['ishchinomi'], ishchiuid: doc['ishchiuid'], dostup: doc['dostup'], ishchidomlar: doc['ishchidomlar']);
  }
}

class OmborModel {
  final String dataId;
  final Timestamp createdTime;
  final String createdTimeString;
  final String createdBy;
  final String createdByUid;
  final String itemUid;
  final String name;
  final String hajmi;
  final String measure;
  final String orderId;
  final String type;
  final Map docs;
  final bool done;
  OmborModel(
      {required this.dataId,
      required this.docs,
      required this.done,
      required this.hajmi,
      required this.measure,
      required this.itemUid,
      required this.name,
      required this.orderId,
      required this.createdTime,
      required this.createdTimeString,
      required this.createdBy,
      required this.createdByUid,
      required this.type});
  factory OmborModel.fromMap(Map doc) {
    return OmborModel(
        dataId: doc['dataId'],
        docs: doc['docs'],
        done: doc['done'],
        hajmi: doc['hajmi'],
        measure: doc['measure'],
        itemUid: doc['itemUid'],
        name: doc['name'],
        orderId: doc['orderId'],
        createdTime: doc['createdTime'],
        createdTimeString: doc['createdTimeString'],
        createdBy: doc['createdBy'],
        createdByUid: doc['createdByUid'],
        type: doc['type']);
  }
}

class PlanModel {
  final String planUid;
  final String obyekt;
  final String obyektUid;
  final String firma;
  final String firmaUid;
  final String binoKey;
  final String bino;

  final String planNomi;
  final Timestamp startTime;
  final String startTimeString;
  final Timestamp endTime;
  final String endTimeString;
  final Timestamp startRealTime;
  final String startTimeRealString;
  final Timestamp endtRealTime;
  final String endTimeRealString;
  final Map manager;
  final Map subContractor;
  final Map foreman;
  final String numIshchilar;
  final Map groups;
  PlanModel(
      {required this.planUid,
      required this.obyekt,
      required this.obyektUid,
      required this.firma,
      required this.firmaUid,
      required this.planNomi,
      required this.startTime,
      required this.startTimeString,
      required this.endTime,
      required this.endTimeString,
      required this.startRealTime,
      required this.startTimeRealString,
      required this.endtRealTime,
      required this.endTimeRealString,
      required this.manager,
      required this.subContractor,
      required this.foreman,
      required this.numIshchilar,
      required this.groups,
      required this.bino,
      required this.binoKey});
  factory PlanModel.fromMap(Map doc) {
    return PlanModel(
        planUid: doc['planUid'],
        obyekt: doc['obyekt'],
        obyektUid: doc['obyektUid'],
        firma: doc['firma'],
        firmaUid: doc['firmaUid'],
        planNomi: doc['planNomi'],
        startTime: doc['startTime'],
        startTimeString: doc['startTimeString'],
        endTime: doc['endTime'],
        endTimeString: doc['endTimeString'],
        startRealTime: doc['startRealTime'].runtimeType == String ? Timestamp.fromMillisecondsSinceEpoch(0) : doc['startRealTime'],
        startTimeRealString: doc['startTimeRealString'],
        endtRealTime: doc['endtRealTime'].runtimeType == String ? Timestamp.fromMillisecondsSinceEpoch(0) : doc['endtRealTime'],
        endTimeRealString: doc['endTimeRealString'],
        manager: doc['manager'],
        subContractor: doc['subContractor'],
        foreman: doc['foreman'],
        numIshchilar: doc['numIshchilar'],
        groups: doc['groups'],
        bino: doc['bino'],
        binoKey: doc['binoKey']);
  }
  Map toMap() {
    return {
      'planUid': planUid,
      'obyekt': obyekt,
      'obyektUid': obyektUid,
      'firma': firma,
      'firmaUid': firmaUid,
      'planNomi': planNomi,
      'startTime': startTime,
      'startTimeString': startTimeString,
      'endTime': endTime,
      'endTimeString': endTimeString,
      'startRealTime': startRealTime,
      'startTimeRealString': startTimeRealString,
      'endtRealTime': endtRealTime,
      'endTimeRealString': endTimeRealString,
      'manager': manager,
      'subContractor': subContractor,
      'foreman': foreman,
      'numIshchilar': numIshchilar,
      'groups': groups,
      'bino': bino,
      'binoKey': binoKey
    };
  }
}

class WalletModel {
  final String orderUid;
  final Map data;
  final String createdBy;
  final String createdByUid;
  final String obyekt;
  final String obyektUid;
  final String firma;
  final String firmaUid;
  final bool confirmedDocs;
  final bool confirmedToBuy;
  final Timestamp createdTime;
  final String createdTimeString;
  WalletModel(
      {required this.confirmedDocs,
      required this.confirmedToBuy,
      required this.createdBy,
      required this.createdByUid,
      required this.data,
      required this.firma,
      required this.firmaUid,
      required this.obyekt,
      required this.obyektUid,
      required this.orderUid,
      required this.createdTime,
      required this.createdTimeString});
  factory WalletModel.fromMap(Map doc) {
    return WalletModel(
      confirmedDocs: doc['confirmedDocs'],
      confirmedToBuy: doc['confirmedToBuy'],
      createdBy: doc['createdBy'],
      createdByUid: doc['createdByUid'],
      data: doc['data'],
      firma: doc['firma'],
      firmaUid: doc['firmaUid'],
      obyekt: doc['obyekt'],
      obyektUid: doc['obyektUid'],
      orderUid: doc['orderUid'],
      createdTime: doc['createdTime'],
      createdTimeString: doc['createdTimeString'],
    );
  }

  Map toMap() {
    return {
      'data': data,
      'createdBy': createdBy,
      'createdByUid': createdByUid,
      'obyekt': obyekt,
      'obyektUid': obyektUid,
      'firma': firma,
      'firmaUid': firmaUid,
      'orderUid': orderUid,
      'confirmedDocs': confirmedDocs,
      'confirmedToBuy': confirmedToBuy,
      'createdTime': createdTime,
      'createdTimeString': createdTimeString
    };
  }
}

class XabarlarModel {}

class DomlarModel {}
