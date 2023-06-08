import 'package:flutter/foundation.dart';
import 'package:latihanuas/config/firebase_auth_config.dart';
import 'package:latihanuas/config/firestore_config.dart';
import 'package:latihanuas/config/sqllite_config.dart';
import 'package:latihanuas/models/catatan_model.dart';
import 'package:uuid/uuid.dart';

class CatatanProvider extends ChangeNotifier {
  final List<CatatanModel> catatans = [];
  final List<CatatanModel> filteredCatatans = [];
  final AuthConfig _auth = AuthConfig();
  final SqliteConfig _sqlite = SqliteConfig();
  final FirestoreConfig _firestore = FirestoreConfig();
  final uuid = const Uuid();

  CatatanModel? _catatan;

  CatatanModel? get getCatatan => _catatan;

  List<CatatanModel> get catatanAll => catatans;
  List<CatatanModel> get catatanFiltered => filteredCatatans;

  void setCatatan (CatatanModel catatanModel) => _catatan = catatanModel;

  void addCatatan(CatatanModel catatanModel) async {
    catatans.add(catatanModel);
    await _sqlite.insertCatatan(catatanModel);
    await _firestore.createOrUpdateNote(catatanModel);
    notifyListeners();
  }

  void removeCatatan(CatatanModel catatanModel) async {
    catatans.remove(catatanModel);
    await _sqlite.deleteCatatan(catatanModel);
    await _firestore.deleteNote(
        catatanModel.id
    );
    notifyListeners();
  }

  void updateCatatan(CatatanModel catatanModel) async {
    catatans[catatans.indexWhere((element) => element.id == catatanModel.id)] = catatanModel;
    await _sqlite.updateCatatan(catatanModel);
    await _firestore.createOrUpdateNote(catatanModel);
    notifyListeners();
  }

  void filterCatatan(String query) {
    if (query.isEmpty) {
      filteredCatatans.clear();
      filteredCatatans.addAll(catatans);
      notifyListeners();
    }
    else {
      filteredCatatans.clear();
      filteredCatatans.addAll(catatans.where((element) => element.catatan.toLowerCase().contains(query.toLowerCase())));
      notifyListeners();
    }
  }

  void fetchCatatan() async{
    final catatan = await SqliteConfig().getCatatans(_auth.user?.uid ?? '');
    catatans.clear();
    filteredCatatans.clear();

    catatans.addAll(catatan);
    filteredCatatans.addAll(catatans);
    notifyListeners();
  }

}