// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/change_providers.dart';

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
  String? _photoUrl;

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
    // Cargar los datos del usuario aquí (igual que antes)
  }

  Future<void> _updateUserProfile() async {
    // Actualizar los datos del perfil de usuario aquí (igual que antes)
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Limpiar SharedPreferences si tienes algún dato de usuario almacenado
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Redirigir al usuario a la pantalla de login y eliminar el historial de navegación
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Cambia esta ruta por la ruta de tu pantalla de login
        (Route<dynamic> route) => false, // Elimina el historial de navegación
      );
    } catch (e) {
      // Manejar cualquier error durante el logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Llamar al método de logout cuando el botón sea presionado
              await _logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resto de los widgets del perfil
            Center(
              child: GestureDetector(
                onTap: () {}, // Lógica para cambiar la foto
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoUrl != null
                      ? NetworkImage(_photoUrl!)
                      : const AssetImage('assets/images/user.jpg') as ImageProvider,
                  child: _photoUrl == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre y Apellido'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Llamar al método de logout cuando el botón sea presionado
                await _logout(context);
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
