import 'dart:convert';
import 'package:http/http.dart' as http;

class SyncInfoProvider {
  static final SyncInfoProvider _instance=SyncInfoProvider._internal();
  SyncInfoProvider._internal(){
    fetchSynchronizationStatus();
  }
  static SyncInfoProvider get instance => _instance;
  bool syncStatus=false;
  Future<void> fetchSynchronizationStatus() async {
    final url = Uri.parse('http://yourapi.com/synchronizationstatus');

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