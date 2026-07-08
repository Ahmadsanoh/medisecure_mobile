class AppointmentModel {
  final int id;
  final int patientId;
  final int doctorId;
  final DateTime dateRdv;
  final int duration;
  final String statut;
  final String? motif;
  final String? notes;
  final DateTime createdAt;
  final String? doctorName;
  final String? specialty;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateRdv,
    required this.duration,
    required this.statut,
    this.motif,
    this.notes,
    required this.createdAt,
    this.doctorName,
    this.specialty,
  });

  bool get isConfirmed => statut == 'confirmed';
  bool get isPending => statut == 'pending';
  bool get isCancelled => statut == 'cancelled';
  bool get isCompleted => statut == 'completed';

  factory AppointmentModel.fromJson(Map<String, dynamic> j) => AppointmentModel(
        id: (j['id'] as num?)?.toInt() ?? 0,
        patientId: (j['patient_id'] as num?)?.toInt() ?? 0,
        doctorId: (j['doctor_id'] as num?)?.toInt() ?? 0,
        dateRdv: j['date_rdv'] != null
            ? DateTime.parse(j['date_rdv'] as String)
            : DateTime.now(),
        duration: (j['duration'] as num?)?.toInt() ?? 30,
        statut: j['statut'] as String? ?? 'pending',
        motif: j['motif'] as String?,
        notes: j['notes'] as String?,
        createdAt: j['created_at'] != null
            ? DateTime.parse(j['created_at'] as String)
            : DateTime.now(),
        doctorName: j['doctor_name'] as String?,
        specialty: j['specialty'] as String?,
      );
}
