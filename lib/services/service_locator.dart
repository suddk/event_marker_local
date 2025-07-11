import '../services/data_service.dart';

class ServiceLocator {
  static late DataService dataService;

  static void setup({bool useMock = true}) {
    dataService = DataService(useMock: useMock);
  }
}
