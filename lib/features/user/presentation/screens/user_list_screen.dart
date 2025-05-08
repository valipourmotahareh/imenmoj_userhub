import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_bloc.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_event.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  Future<void> _downloadImage(BuildContext context, String url) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مجوز ذخیره‌سازی داده نشد')),
      );
      return;
    }

    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطا در دسترسی به حافظه')),
        );
        return;
      }

      final fileName = url.split('/').last;

      final savedDir = Directory(directory.path);
      if (!await savedDir.exists()) {
        await savedDir.create(recursive: true);
      }

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('دانلود شروع شد: $fileName')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطا در شروع دانلود')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در دانلود تصویر')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUsersEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست کاربران'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/user_form');
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final users = state.users;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: user.avatarUrl.isNotEmpty
                        ? ClipOval(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.file(
                          File(user.avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : const Icon(Icons.person, size: 48),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.pushNamed(
                            context,
                            '/user_form',
                            arguments: user,
                          );
                        } else if (value == 'delete') {
                          context.read<UserBloc>().add(DeleteUser(user.id));
                        } else if (value == 'download') {
                          _downloadImage(context, user.avatarUrl);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                        const PopupMenuItem(value: 'delete', child: Text('حذف')),
                        const PopupMenuItem(value: 'download', child: Text('دانلود عکس')),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
