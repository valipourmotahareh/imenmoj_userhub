import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imenmoj_userhub/core/widgets/custom_button.dart';
import 'package:imenmoj_userhub/core/widgets/custom_text_field.dart';
import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_bloc.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_event.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _avatarImage;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is UserModel) {
      _user = args;
      _nameController.text = _user!.name;
      _emailController.text = _user!.email;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('user_form_screen.select_gallery'.tr()),
                onTap: () async {
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context, picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('user_form_screen.taking_picture_camera'.tr()),
                onTap: () async {
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context, picked);
                },
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final avatarUrl = _avatarImage?.path ?? _user?.avatarUrl ?? '';

      if (_user == null) {
        final newUser = UserModel(
          id: UniqueKey().toString(),
          name: name,
          email: email,
          avatarUrl: avatarUrl,
        );
        context.read<UserBloc>().add(CreateUser(newUser));
      } else {
        final updatedUser = _user!.copyWith(
          name: name,
          email: email,
          avatarUrl: avatarUrl,
        );
        context.read<UserBloc>().add(UpdateUser(updatedUser));
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'user_form_screen.user_edit'.tr()
              : 'user_form_screen.user_create'.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : (_user?.avatarUrl.isNotEmpty ?? false)
                          ? NetworkImage(_user!.avatarUrl) as ImageProvider
                          : null,
                  child:
                      _avatarImage == null && (_user?.avatarUrl.isEmpty ?? true)
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                labelText: 'user_form_screen.user_name'.tr(),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'user_form_screen.user_email'.tr(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _submit,
                text: 'user_form_screen.user_save'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
