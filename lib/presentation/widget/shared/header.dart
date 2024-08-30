import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          "FINANCYBANK",
          style: GoogleFonts.squadaOne().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 31, 8, 236),
              letterSpacing: 7,
              height: 0),
        ),
      ],
    );
  }
}
