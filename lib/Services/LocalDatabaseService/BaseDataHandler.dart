import 'package:exdata_collector/Models/AbstractModel.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/IDataHandler.dart';

abstract class BaseDataHandler implements IDataHandler {
  @override
  Future<List<Object>> loadByParam<T>(String paramName, T value) async {
    List<AbstractModel> objects = (await loadAll()).whereType<AbstractModel>().toList();
    List<Object> filtered = [];

    for (var element in objects) {
      final json = element.toJson();
      if (json[paramName].toString() == value) {
        filtered.add(element);
      }
    }

    return filtered;
  }
}
