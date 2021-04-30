import 'package:vagabond/models/shelter.dart';
import 'package:vagabond/utils/env.dart';
import 'package:vagabond/utils/logger.dart';
import 'package:supabase/supabase.dart';

final db = SupabaseClient(supabaseUrl, supabaseKey);

class Api {
  static bool _isSuccessful(int? statusCode) => statusCode != null && statusCode >= 200 && statusCode <= 299;

  static dynamic _handleResponse(response) {
    log.i('<- [${response.status}] ${response.data}');
    if (_isSuccessful(response.status)) {
      return response.data;
    } else {
      throw response.error?.toJson() ?? Exception('Internal Error: ${response.toJson()}');
    }
  }

  static Future<List<Shelter>> getAllShelters() async {
    final response = await db.from('shelters').select('id, name, created_at, latitude, longitude').execute();
    final data = _handleResponse(response);
    return List.from(data).map((json) => Shelter.fromJson(json)).toList();
  }

  static Future<Shelter> getShelterDetails(String shelterId) async {
    final response = await db.from('shelters').select().eq('id', shelterId).limit(1).execute();
    final data = _handleResponse(response);
    return List.from(data).map((json) => Shelter.fromJson(json)).toList()[0];
  }

  static Future<void> addShelter(Shelter shelter) async {
    final json = shelter.toJson()..remove('id');
    final response = await db.from('shelters').insert(json).execute();
    _handleResponse(response);
  }

  static Future<void> updateShelter(Shelter shelter) async {
    final response = await db.from('shelters').update(shelter.toJson()).eq('id', shelter.id).execute();
    _handleResponse(response);
  }

  static Future<void> deleteShelter(String shelterId) async {
    final response = await db.from('shelters').delete().eq('id', shelterId).execute();
    _handleResponse(response);
  }
}
