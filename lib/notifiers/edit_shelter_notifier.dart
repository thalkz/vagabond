import 'package:latlong2/latlong.dart';
import 'package:vagabond/models/shelter.dart';
import 'package:vagabond/utils/api.dart';
import 'package:vagabond/utils/logger.dart';
import 'package:flutter/material.dart';

class EditShelterNotifier extends ChangeNotifier {
  EditShelterNotifier({required this.shelterId}) {
    if (shelterId != null) {
      getShelter();
    }
  }

  final String? shelterId;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  Shelter? _shelter;
  bool _loading = false;

  Shelter? get shelter => _shelter;
  bool get loading => _loading;

  Shelter _readShelter() {
    final latitude = double.tryParse(latitudeController.value.text) ?? 0.0;
    final longitude = double.tryParse(latitudeController.value.text) ?? 0.0;

    return Shelter(
      id: shelterId ?? '',
      createdAt: DateTime.now(),
      name: nameController.value.text,
      description: descriptionController.value.text,
      opened: true, // TODO: Show opened or not
      location: LatLng(latitude, longitude),
    );
  }

  Future<void> save() async {
    try {
      _loading = true;
      notifyListeners();
      if (shelterId == null) {
        await Api.addShelter(_readShelter());
      } else {
        await Api.updateShelter(_readShelter());
      }
    } catch (error, trace) {
      log.w('Failed to add shelter with id=$shelterId', error, trace);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> delete() async {
    try {
      _loading = true;
      notifyListeners();
      if (shelterId != null) {
        await Api.deleteShelter(shelterId!);
      }
    } catch (error, trace) {
      log.w('Failed to add shelter with id=$shelterId', error, trace);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getShelter() async {
    try {
      if (shelterId == null) throw ('shelterId is null');
      _loading = true;
      notifyListeners();
      _shelter = await Api.getShelterDetails(shelterId!);
      nameController.text = _shelter?.name ?? 'name';
      descriptionController.text = _shelter?.description ?? 'description';
      latitudeController.text = _shelter?.location.latitude.toString() ?? '0.0';
      longitudeController.text = _shelter?.location.latitude.toString() ?? '0.0';
    } catch (error, trace) {
      log.w('Failed to get shelter with id=$shelterId', error, trace);
    }
    _loading = false;
    notifyListeners();
  }
}
