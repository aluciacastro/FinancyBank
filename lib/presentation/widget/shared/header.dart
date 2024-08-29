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
          "INGEMATH",
          style: GoogleFonts.squadaOne().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFF833D),
              letterSpacing: 7,
              height: 0),
        ),
        Text(
          "MONEY",
          style: GoogleFonts.squadaOne().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7ED957),
              letterSpacing: 3,
              height: 0),
        ),
      ],
    );
  }
}
