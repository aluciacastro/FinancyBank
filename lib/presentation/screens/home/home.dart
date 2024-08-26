import 'package:cesarpay/presentation/screens/home/UserProfileScreen.dart';
import 'package:cesarpay/presentation/screens/home/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String document;

  const HomeScreen({super.key, required this.document});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Definir las pantallas para cada pestaña
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MainScreen(document: widget.document), // Pantalla principal
      Container(), // Placeholder para estadísticas
      const UserProfileScreen(), // Pantalla de perfil de usuario
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navegar a la pantalla de perfil si el índice es 2
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill),
              label: 'stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2_square_stack),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ]),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: _screens[
          _currentIndex], // Cambia el contenido según el índice seleccionado
    );
  }
}
