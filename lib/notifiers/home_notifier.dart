import 'package:vagabond/utils/api.dart';
import 'package:vagabond/models/shelter.dart';
import 'package:vagabond/utils/logger.dart';
import 'package:flutter/material.dart';

class HomeNotifier extends ChangeNotifier {
  HomeNotifier() {
    refreshShelters();
  }

  List<Shelter>? _shelters;
  bool _loading = false;

  List<Shelter> get shelters => _shelters ?? [];
  bool get loading => _loading;

  Future<void> refreshShelters() async {
    try {
      _loading = true;
      notifyListeners();
      _shelters = await Api.getAllShelters();
    } catch (error, trace) {
      log.w('Failed to refresh shelters', error, trace);
    }
    _loading = false;
    notifyListeners();
  }
}
