import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

poppinsText({text, color, fontWeight, double? fontSize, textAlign}) {
  return Text(text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize));
}

interText({text, color, double? fontSize, fontWeight}) {
  return Text(text,
      style: GoogleFonts.inter(
          color: color, fontWeight: fontWeight, fontSize: fontSize));
}
