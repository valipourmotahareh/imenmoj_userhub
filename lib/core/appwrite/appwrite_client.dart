import 'package:appwrite/appwrite.dart';

class AppwriteInitializer {
  static late Client client;
  static late Account account;

  static Future<void> init() async {
    client = Client()
      ..setEndpoint('https://fra.cloud.appwrite.io/v1')
      ..setProject('68190d20000af55a9c7f')
      ..setSelfSigned(status: true);

    account = Account(client);
  }
}
