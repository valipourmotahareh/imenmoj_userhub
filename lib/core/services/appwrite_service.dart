import 'package:appwrite/appwrite.dart';

class AppWriteService {
  static final client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject('your_project_id');

  static final account = Account(client);
  static final database = Databases(client);
  static final storage = Storage(client);
}