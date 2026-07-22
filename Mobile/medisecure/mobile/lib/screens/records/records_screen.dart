import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import 'patient_records_screen.dart';
import 'doctor_records_screen.dart';
import 'medical_record_detail_screen.dart';

class RecordsScreen extends ConsumerWidget {
  final int? patientId;
  const RecordsScreen({super.key, this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);

    if (patientId != null) {
      return MedicalRecordDetailScreen(patientId: patientId);
    }

    return switch (role) {
      'doctor' || 'nurse' => const DoctorRecordsScreen(),
      _ => const PatientRecordsScreen(),
    };
  }
}
