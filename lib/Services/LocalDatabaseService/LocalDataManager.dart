import 'package:exdata_collector/Services/LocalDatabaseService/BoatDataHandler.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/IDataHandler.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/RaceDataHandler.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/RunDataHandler.dart';

class LocalDataManager {
  final List<IDataHandler> _handlers = [];

  static final LocalDataManager shared = LocalDataManager._internal();


  LocalDataManager._internal() {
    _handlers.addAll([
      BoatDataHandler(),
      RaceDataHandler(),
      RunDataHandler(),
    ]);
  }

  Future<void> save(Object model) async {
    for (var handler in _handlers) {
      if (handler.canHandle(model.runtimeType)) {
        await handler.save(model);
        return;
      }
    }
    throw Exception("No handler found for ${model.runtimeType}");
  }
  Future<T>load<T>(Type modelType,int id) async {
    for (var handler in _handlers) {
      if (handler.canHandle(modelType)) {
        return await handler.load(id) as T;
      }
    }
    throw Exception("No handler found for $modelType");
  }

  Future<List<T>> loadAll<T>(Type modelType) async {
    for (var handler in _handlers) {
      if (handler.canHandle(modelType)) {
        return (await handler.loadAll()).whereType<T>().toList();
      }
    }
    throw Exception("No handler found for $modelType");
  }
  Future<List<T>> loadByParam<T>(Type modelType,String paramName, String stringifiedValue) async {
    for (var handler in _handlers) {
      if (handler.canHandle(modelType)) {
        return (await handler.loadByParam(paramName, stringifiedValue)).whereType<T>().toList();
      }
    }
    throw Exception("No handler found for $modelType");
  }
}
