import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Services/LocalSaver.dart';

class SyncInfoProvider {
  static final SyncInfoProvider _instance=SyncInfoProvider._internal();
  SyncInfoProvider._internal(){
    fetchSynchronizationStatus();
  }
  static SyncInfoProvider get instance => _instance;
  bool syncStatus=false;
  Future<void> fetchSynchronizationStatus() async {
    String baseUrl = await LocalSaver.getBackendUrl();
    final url = Uri.parse('$baseUrl/synchronizationstatus');

    try {
      final response = await http.get(url);
      //TODO : Provide database status{ listBoat,listRuns}
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        syncStatus = data['synchronizationstatus'];

        print('Synchronization Status: $syncStatus');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}