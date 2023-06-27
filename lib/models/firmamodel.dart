class FirmaModel {
  final String firmauid;
  final String firmanomi;
  final String firmainn;
  final String director;
  final Map obyektlar;
  final Map payment;
  final Map ishchilar;
  final String xabarlar;
  final Map wallet;
  final String logoUrl;

  FirmaModel(
      {required this.firmauid,
      required this.firmanomi,
      required this.firmainn,
      required this.director,
      required this.obyektlar,
      required this.payment,
      required this.ishchilar,
      required this.xabarlar,
      required this.wallet,
      required this.logoUrl});
  factory FirmaModel.fromDocument(Map<String, dynamic> documentSnapshot) {
    return FirmaModel(
      firmauid: documentSnapshot['firmauid'],
      firmanomi: documentSnapshot['firmanomi'],
      firmainn: documentSnapshot['firmainn'],
      director: documentSnapshot['director'],
      obyektlar: documentSnapshot['obyektlar'],
      payment: documentSnapshot['payment'],
      ishchilar: documentSnapshot['ishchilar'],
      xabarlar: documentSnapshot['xabarlar'],
      wallet: documentSnapshot['wallet'],
      logoUrl: documentSnapshot['logoUrl'],
    );
  }
}

class FirmaXabarlar {
  final String type;
  final String uid;
  final String person;
  final bool isActive;
  FirmaXabarlar({required this.type, required this.uid, required this.person, required this.isActive});

  factory FirmaXabarlar.fromMap(doc) {
    return FirmaXabarlar(type: doc['type'], uid: doc['personuid'], person: doc['person'], isActive: doc['isActive']);
  }
}
