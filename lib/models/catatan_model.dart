class CatatanModel {
  late String id;
  late String catatan;
  late String owner;
  late String dateCreated;

  CatatanModel({
    required this.id,
    required this.catatan,
    required this.owner,
    required this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catatan': catatan,
      'owner': owner,
      'dateCreated': dateCreated,
    };
  }

  CatatanModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    catatan = map['catatan'];
    owner = map['owner'];
    dateCreated = map['dateCreated'];
  }
}