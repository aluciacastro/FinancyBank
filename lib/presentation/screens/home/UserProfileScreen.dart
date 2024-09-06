import 'package:cesarpay/providers/change_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = 'userProfile';

  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController documentController;
  late TextEditingController dateController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    documentController = TextEditingController();
    dateController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userNotifier = ref.read(userProvider.notifier);
    await userNotifier.loadUserData();
    final user = ref.watch(userProvider);
    if (user != null) {
      nameController.text = user.name;
      documentController.text = user.documentId;
      dateController.text = user.dateOfBirth;
      emailController.text = user.email;
      phoneController.text = user.phone;
    }
  }

  Future<void> _updateUserProfile() async {
    final userNotifier = ref.read(userProvider.notifier);
    await userNotifier.updateUserData(
      email: emailController.text,
      phone: phoneController.text,
      name: nameController.text,
      document: documentController.text,
      dateOfBirth: dateController.text,
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre y Apellido'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: documentController,
              decoration: const InputDecoration(labelText: 'Cédula'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Número de Teléfono'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
