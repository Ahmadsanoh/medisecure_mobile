import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/medical_record_model.dart';
import 'api_client.dart';

class MedicalRecordService {
  final _dio = ApiClient().dio;

  Future<MedicalRecordModel> getMyRecord() async {
    final res = await _dio.get('records/my');
    return MedicalRecordModel.fromJson(res.data);
  }

  Future<MedicalRecordModel> getPatientRecord(int patientId) async {
    final res = await _dio.get('records/$patientId');
    return MedicalRecordModel.fromJson(res.data);
  }

  Future<MedicalRecordModel> updateRecord(
      int patientId, Map<String, dynamic> data) async {
    final res = await _dio.put('records/$patientId', data: data);
    return MedicalRecordModel.fromJson(res.data);
  }

  Future<PrescriptionModel> addPrescription(
      int patientId, Map<String, dynamic> data) async {
    final res = await _dio.post('records/$patientId/prescriptions', data: data);
    return PrescriptionModel.fromJson(res.data);
  }

  Future<void> deactivatePrescription(int patientId, int rxId) async {
    await _dio.delete('records/$patientId/prescriptions/$rxId');
  }

  Future<ConsultationModel> addConsultation(
      int patientId, Map<String, dynamic> data) async {
    final res = await _dio.post('records/$patientId/consultations', data: data);
    return ConsultationModel.fromJson(res.data);
  }

  Future<LabResultModel> addLabResult(
      int patientId, Map<String, dynamic> data) async {
    final res = await _dio.post('records/$patientId/lab-results', data: data);
    return LabResultModel.fromJson(res.data);
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    final res = await _dio.get('patients/');
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<void> addVitals(int patientId, Map<String, dynamic> data) async {
    await _dio.post('records/$patientId/vitals/', data: data);
  }

  /// Télécharge le dossier PDF et le sauvegarde dans le dossier Documents.
  /// Retourne le chemin du fichier sauvegardé.
  Future<String> downloadDossierPdf({int? patientId}) async {
    final path = patientId != null ? 'records/$patientId/pdf/' : 'records/my/pdf/';
    final res = await _dio.get(
      path,
      options: Options(responseType: ResponseType.bytes),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'dossier_${patientId ?? 'moi'}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(res.data as List<int>);
    return file.path;
  }
}

final recordServiceProvider = Provider((_) => MedicalRecordService());

final myRecordProvider =
    FutureProvider.autoDispose<MedicalRecordModel>((ref) async {
  return ref.watch(recordServiceProvider).getMyRecord();
});

final patientsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(recordServiceProvider).getPatients();
});
