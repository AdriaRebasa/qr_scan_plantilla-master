import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';
  
  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if (nouScan.tipus == tipusSeleccionat) {
      scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  Future carregarScans() async {
    final scansCarregats = await DBProvider.db.getAllScans();
    scans = [...scansCarregats];
    notifyListeners();
  }

  Future carregarScansPerTipus(String tipus) async {
    final scansCarregats = await DBProvider.db.getScansByType(tipus);
    scans = [...scansCarregats];
    tipusSeleccionat = tipus;
    notifyListeners();
  }

  Future borrarTotsElsScans() async {
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  Future borrarScanPerId(int id) async {
    await DBProvider.db.deleteScanById(id);
    scans.removeWhere((scan) => scan.id == id);
    notifyListeners();
  }

}

