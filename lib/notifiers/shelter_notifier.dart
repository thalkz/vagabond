import 'package:vagabond/models/shelter.dart';
import 'package:vagabond/utils/api.dart';
import 'package:vagabond/utils/logger.dart';
import 'package:flutter/material.dart';

class ShelterNotifier extends ChangeNotifier {
  ShelterNotifier({required this.shelterId}) {
    refreshShelter();
  }
  
  final String shelterId;

  Shelter? _shelter;
  bool _loading = false;

  Shelter? get shelter => _shelter;
  bool get loading => _loading;

  Future<void> refreshShelter() async {
    try {
      _loading = true;
      notifyListeners();
      _shelter = await Api.getShelterDetails(shelterId);
    } catch (error, trace) {
      log.w('Failed to shelter with id=$shelterId', error, trace);
    }
    _loading = false;
    notifyListeners();
  }
}
