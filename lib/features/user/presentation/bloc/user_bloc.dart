import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  UserBloc(this.repository, this.flutterLocalNotificationsPlugin) : super(UserInitial()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError('خطا در بارگذاری کاربران'));
      }
    });
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  /// Helper method to send notifications
  Future<void> _sendNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'user_channel',
      'User Notifications',
      channelDescription: 'اعلان‌های مربوط به کاربران',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await repository.deleteUser(event.userId);
      add(LoadUsersEvent());
      await _sendNotification('حذف کاربر', 'کاربر با موفقیت حذف شد.');
    } catch (e) {
      emit(UserError('خطا در حذف کاربر'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await repository.updateUser(event.user);
      await _sendNotification('ویرایش کاربر', 'کاربر با موفقیت ویرایش شد.');
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserError('خطا در ویرایش کاربر'));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      await repository.createUser(event.user);

      await _sendNotification(
        'کاربر جدید ایجاد شد',
        'کاربر ${event.user.name} با موفقیت اضافه شد.',
      );

      add(LoadUsersEvent());
    } catch (e) {
      emit(UserError('خطا در ایجاد کاربر'));
    }
  }
}
