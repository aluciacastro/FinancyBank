import 'package:cesarpay/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = 'userProfile';

  const UserProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserData();
    final user = userProvider.user;
    if (user != null) {
      nameController.text = user.name;
      documentController.text =
          user.documentId; // Assuming you have this in User model
      dateController.text =
          user.dateOfBirth; // Assuming you have this in User model
      emailController.text = user.email;
      phoneController.text = user.phone;
    }
  }

  Future<void> _updateUserProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateUserData(
      email: emailController.text,
      phone: phoneController.text,
      name: nameController.text,
      document: '',
      dateOfBirth: '',
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
              decoration:
                  const InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration:
                  const InputDecoration(labelText: 'Número de Teléfono'),
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
