import 'package:exdata_collector/Models/AbstractModel.dart';

abstract class IDataHandler {
  bool canHandle(Type model);
  Future<void> save(Object model);
  Future<Object?> load(int id);
  Future<List<Object>> loadAll();
  Future<void> deleteAll();
  Future<List<Object>> loadByParam<T>(String paramName,T value)
  async {
    List<AbstractModel> objects = (await loadAll()).whereType<AbstractModel>().toList();

    List<Object> filtered = [];

    objects.forEach((element) {
      final json = element.toJson();
      if (json[paramName] == value) {
        filtered.add(element);
      }
    });

    return filtered;

  }
}
