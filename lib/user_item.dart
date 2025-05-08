import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imenmoj_userhub/config/router/routes.dart';
import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';

class UserItem extends StatelessWidget {
  final UserModel user;
  final void Function() onDelete;
  final void Function() onDownload;

  const UserItem({
    super.key,
    required this.user,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final avatarFile = File(user.avatarUrl);
    final hasAvatar = user.avatarUrl.isNotEmpty && avatarFile.existsSync();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:hasAvatar
                  ? Image.file(
                avatarFile,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 32, color: Colors.grey),
              ),
            ),

            const SizedBox(width: 16),

            /// Name & Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Popup Menu
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  context.pushNamed(Routes.userFormScreen, extra: user);
                } else if (value == 'delete') {
                  onDelete();
                } else if (value == 'download') {
                  onDownload();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('user_list_screen.edit'.tr()),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('user_list_screen.delete'.tr()),
                ),
                PopupMenuItem(
                  value: 'download',
                  child: Text('user_list_screen.download_image'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
