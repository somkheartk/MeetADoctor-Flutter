import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/healthcare/healthcare_onboarding_screen.dart';

void main() {
  runApp(const DoctorAppointment());
}

class DoctorAppointment extends StatelessWidget {
  const DoctorAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.kanitTextTheme(),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.kanit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.kanit(fontWeight: FontWeight.w500),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: GoogleFonts.kanit(fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.kanit(),
          hintStyle: GoogleFonts.kanit(color: Colors.grey.shade600),
        ),
      ),
      home: const HealthcareOnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
