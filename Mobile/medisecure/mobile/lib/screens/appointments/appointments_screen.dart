import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import 'patient_appointments_screen.dart';
import 'doctor_appointments_screen.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);

    return switch (role) {
      'doctor' || 'nurse' => const DoctorAppointmentsScreen(),
      _ => const PatientAppointmentsScreen(),
    };
  }
}
