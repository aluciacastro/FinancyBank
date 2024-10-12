// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cesarpay/presentation/screens/login/Login_Screen.dart';
import 'package:cesarpay/providers/change_providers.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  final ImagePicker _picker = ImagePicker();

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
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.loadUserData();
      final user = ref.watch(userProvider);

      if (user != null) {
        nameController.text = user.name;
        documentController.text = user.documentId;
        dateController.text = user.dateOfBirth;
        emailController.text = user.email;
        phoneController.text = user.phone;
        setState(() {
          _photoUrl = user.photoUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cargar los datos del usuario.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $e')),
      );
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.updateUserData(
        email: emailController.text,
        phone: phoneController.text,
        name: nameController.text,
        document: documentController.text,
        dateOfBirth: dateController.text,
        photoUrl: _photoUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar los datos: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await _uploadImage(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar la imagen: $e')),
      );
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String photoUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _photoUrl = photoUrl;
      });

      // Actualiza la URL de la imagen en la base de datos
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.updateUserData(
        email: emailController.text,
        phone: phoneController.text,
        name: nameController.text,
        document: documentController.text,
        dateOfBirth: dateController.text,
        photoUrl: _photoUrl,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen: $e')),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
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
          ],
        ),
      ),
    );
  }
}