import 'package:cesarpay/presentation/formulas/InvestmentEvaluationScreen.dart';
import 'package:cesarpay/presentation/formulas/amortization_screen.dart';
import 'package:cesarpay/presentation/formulas/bond_screen.dart';
import 'package:cesarpay/presentation/formulas/compound_interest_screen.dart';
import 'package:cesarpay/presentation/formulas/gradient_screen.dart';
import 'package:cesarpay/presentation/formulas/inflation_Screen.dart';
import 'package:cesarpay/presentation/formulas/screen_tirr.dart';
import 'package:cesarpay/presentation/formulas/simple_interest_screen.dart';
import 'package:cesarpay/presentation/formulas/uvr_screen.dart';
import 'package:cesarpay/presentation/screens/home/UserProfileScreen.dart';
import 'package:cesarpay/presentation/screens/home/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../formulas/annuities_screen.dart';
class HomeScreen extends StatefulWidget {
  final String document;

  const HomeScreen({super.key, required this.document});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MainScreen(document: widget.document),
      Container(), // Placeholder para estadísticas
      const UserProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfileScreen()),
      );
    }
  }

  void _showOptionsMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return SingleChildScrollView( 
      child:  Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.chart_pie),
              title: const Text('Interés Compuesto'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompoundInterestScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.chart_bar),
              title: const Text('Interés Simple'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleInterestScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gradient),
              title: const Text('Gradiente'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GradientScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Inflation'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InflationScreen(),
                  ),
                );
              },
            ),
             ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Anualidades'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnnuitiesScreen(),
                  ),
                );
              },
            ),
             ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Alternativas de Inversion'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvestmentEvaluationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.align_vertical_bottom_rounded),
              title: const Text('Amortizacion'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AmortizationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('UVR'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UVRScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('TIR'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TirScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text('BONOS'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BondScreen(),
                  ),
                );
              },
            ),
          ],
        ),
       ),
      );
    },
  );
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
              icon: Icon(CupertinoIcons.person_2_square_stack),
              label: 'profile',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionsMenu(context),
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
      body: _screens[_currentIndex],
    );
  }
}
