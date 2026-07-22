import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medisecure/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../services/appointment_service.dart';
import '../../services/user_service.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_dialog.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';
import '../../services/logger_service.dart';

// ── Booking state ─────────────────────────────────────────────────────────────

class _BookingData {
  int? specialtyId;
  String? specialtyName;
  int? doctorId;
  String? doctorName;
  DateTime? date;
  String? timeSlot;
  String? motif;
}

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});
  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _step = 0;
  final _data = _BookingData();
  bool _loading = false;
  DateTime? _focusedDate;

  void _next() => setState(() => _step++);
  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  Future<void> _confirm() async {
    if (_data.doctorId == null || _data.date == null || _data.timeSlot == null) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showConfirmDialog(
      context,
      title: l10n.bookingConfirmTitle,
      message: l10n.bookingConfirmMessage,
      confirmLabel: l10n.bookingConfirmAction,
      confirmColor: const Color(0xFF16A34A),
    );
    if (!confirm) return;

    setState(() => _loading = true);
    try {
      final parts = _data.timeSlot!.split(':');
      final dateRdv = _data.date!.copyWith(
          hour: int.parse(parts[0]), minute: int.parse(parts[1]), second: 0);
      await ref.read(appointmentServiceProvider).createAppointment(
            doctorId: _data.doctorId!,
            dateRdv: dateRdv,
            motif: _data.motif,
          );
      log.i(
          '✅ SCÉNARIO: Réservation terminée avec succès pour ${_data.doctorName}');
      ref.invalidate(appointmentsProvider);
      if (mounted) {
        showSuccessSnackBar(
            context, AppLocalizations.of(context)!.bookingSuccess);
        context.go('/appointments');
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      l10n.bookingStepSpecialty,
      l10n.bookingStepDoctor,
      l10n.bookingStepSlot,
      l10n.bookingStepConfirm
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('${l10n.bookingTitle} — ${steps[_step]}'),
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_step + 1) / steps.length,
            backgroundColor: Colors.white30,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (_step) {
          0 => _buildStep0(),
          1 => _buildStep1(),
          2 => _buildStep2(),
          _ => _buildStep3(),
        },
      ),
    );
  }

  // ── Step 0: Specialty (from API) ────────────────────────────────────────────

  Widget _buildStep0() {
    final l10n = AppLocalizations.of(context)!;
    final specialtiesAsync = ref.watch(specialtiesProvider);
    return specialtiesAsync.when(
      loading: () => Column(children: [
        _StepTitle(l10n.bookingLoadingSpecialties),
        Expanded(
            child: ListView.separated(
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => const ShimmerBox(height: 80, radius: 16),
        )),
      ]),
      error: (e, st) => MsErrorView(
          error: e,
          stackTrace: st,
          onRetry: () => ref.invalidate(specialtiesProvider)),
      data: (specialties) => Column(children: [
        _StepTitle(l10n.bookingSelectSpecialty),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: specialties.map((s) {
              final selected = _data.specialtyId == s.id;
              return GestureDetector(
                onTap: () => setState(() {
                  _data.specialtyId = s.id;
                  _data.specialtyName = s.nom;
                  _data.doctorName = null;
                  log.v('Booking: Spécialité sélectionnée => ${s.nom}');
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF1A56DB)
                          : const Color(0xFFE5E9EF),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(children: [
                    const Icon(Icons.local_hospital_outlined,
                        size: 26, color: Color(0xFF1A56DB)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(s.nom,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? const Color(0xFF1A56DB)
                                    : const Color(0xFF1E293B)))),
                    if (selected)
                      const Icon(Icons.check_circle,
                          color: Color(0xFF1A56DB), size: 18),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        MsButton(
          label: l10n.bookingActionNext,
          onPressed: _data.specialtyId != null ? _next : null,
        ),
      ]),
    );
  }

  // ── Step 1: Doctor (from API filtered by specialty) ─────────────────────────

  Widget _buildStep1() {
    final l10n = AppLocalizations.of(context)!;
    final doctorsAsync = ref.watch(doctorsProvider(_data.specialtyId));
    return doctorsAsync.when(
      loading: () => Column(children: [
        _StepTitle(l10n.bookingLoadingDoctors),
        Expanded(
            child: ListView.separated(
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => const AppointmentCardSkeleton(),
        )),
      ]),
      error: (e, st) => MsErrorView(
          error: e,
          stackTrace: st,
          onRetry: () => ref.invalidate(doctorsProvider(_data.specialtyId))),
      data: (doctors) => Column(children: [
        _StepTitle(l10n.bookingSelectDoctorIn(_data.specialtyName ?? "")),
        if (doctors.isEmpty)
          Expanded(
            child: Center(
              child: Text(l10n.bookingNoDoctors,
                  style: const TextStyle(color: Color(0xFF64748B))),
            ),
          )
        else
          Expanded(
            child: ListView(
              children: doctors.map((d) {
                final selected = _data.doctorId == d.id;
                return GestureDetector(
                  onTap: () => setState(() {
                    _data.doctorId = d.id;
                    _data.doctorName = d.fullName;
                    log.v('Booking: Médecin sélectionné => ${d.fullName}');
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF1A56DB)
                            : const Color(0xFFE5E9EF),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFF1F5F9),
                        child: Text(
                          '${d.prenom[0]}${d.nom[0]}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A56DB)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(d.fullName,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700)),
                            Text(
                              '${d.specialty?.nom ?? _data.specialtyName ?? ""}${d.rating != null ? " · ⭐ ${d.rating}" : ""}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            if (d.bio != null) ...[
                              const SizedBox(height: 4),
                              Text(d.bio!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ])),
                      if (selected)
                        const Icon(Icons.check_circle,
                            color: Color(0xFF1A56DB)),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 12),
        MsButton(
            label: l10n.bookingActionNext,
            onPressed: _data.doctorId != null ? _next : null),
      ]),
    );
  }

  // ── Step 2: Time slot (from API) ────────────────────────────────────────────

  Widget _buildStep2() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    _data.date ??= DateTime.now().add(const Duration(days: 1));
    _focusedDate ??= _data.date!;
    final dateStr = DateFormat('yyyy-MM-dd').format(_data.date!);
    final slotsAsync = ref.watch(
        _availableSlotsProvider((doctorId: _data.doctorId!, date: dateStr)));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _StepTitle(l10n.bookingSelectSlot),

      // Month Navigation Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _focusedDate!.isAfter(DateTime.now())
                ? () => setState(() {
                      _focusedDate = DateTime(_focusedDate!.year,
                          _focusedDate!.month - 1, _focusedDate!.day);
                    })
                : null,
          ),
          Text(
            DateFormat('MMMM yyyy', locale).format(_focusedDate!),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _focusedDate = DateTime(_focusedDate!.year,
                  _focusedDate!.month + 1, _focusedDate!.day);
            }),
          ),
        ],
      ),
      const SizedBox(height: 10),

      // Calendar Grid
      SizedBox(
        height: 280, // Approximate height for 5-6 rows
        child: _buildCalendarGrid(locale),
      ),
      const SizedBox(height: 16),
      Text(l10n.bookingAvailableSlots,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B))),
      const SizedBox(height: 10),
      Expanded(
        child: slotsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 20),
            child: SlotGridSkeleton(),
          ),
          error: (e, st) => MsErrorView(
              error: e,
              stackTrace: st,
              onRetry: () => ref.invalidate(_availableSlotsProvider((
                    doctorId: _data.doctorId!,
                    date: DateFormat('yyyy-MM-dd').format(_data.date!)
                  )))),
          data: (slots) {
            if (slots.isEmpty) {
              return Center(
                child: Text(l10n.bookingNoSlots,
                    style: const TextStyle(color: Color(0xFF64748B))),
              );
            }
            final cols =
                (MediaQuery.of(context).size.width / 90).floor().clamp(3, 5);
            return GridView.count(
              crossAxisCount: cols,
              childAspectRatio: 2.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: slots.map((slot) {
                final time = slot['time'] as String;
                final taken = !(slot['available'] as bool? ?? true);
                final selected = _data.timeSlot == time;
                return GestureDetector(
                  onTap: taken
                      ? null
                      : () => setState(() => _data.timeSlot = time),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: taken
                          ? const Color(0xFFF8FAFC)
                          : selected
                              ? const Color(0xFF1A56DB)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: taken
                            ? const Color(0xFFF1F5F9)
                            : selected
                                ? const Color(0xFF1A56DB)
                                : const Color(0xFFE2E8F0),
                        width: selected ? 2 : 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(time,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: taken
                              ? const Color(0xFFCBD5E1)
                              : selected
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                        )),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      MsButton(
          label: l10n.bookingActionNext,
          onPressed: _data.timeSlot != null ? _next : null),
    ]);
  }

  Widget _buildCalendarGrid(String locale) {
    final firstDay = DateTime(_focusedDate!.year, _focusedDate!.month, 1);
    final lastDay = DateTime(_focusedDate!.year, _focusedDate!.month + 1, 0);
    final startOffset = firstDay.weekday - 1; // 0 for Monday
    final daysInMonth = lastDay.day;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 7 + daysInMonth + startOffset,
      itemBuilder: (context, index) {
        if (index < 7) {
          final dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
          if (locale == 'en') {
            dayLabels.setAll(0, ['M', 'T', 'W', 'T', 'F', 'S', 'S']);
          }
          return Center(
            child: Text(dayLabels[index],
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8))),
          );
        }
        final dayIndex = index - 7 - startOffset + 1;
        if (dayIndex <= 0) return const SizedBox.shrink();

        final d = DateTime(_focusedDate!.year, _focusedDate!.month, dayIndex);
        final isPast =
            d.isBefore(DateTime.now().subtract(const Duration(days: 1)));
        final isSelected = _data.date?.year == d.year &&
            _data.date?.month == d.month &&
            _data.date?.day == d.day;

        return GestureDetector(
          onTap: isPast
              ? null
              : () => setState(() {
                    _data.date = d;
                    _data.timeSlot = null;
                  }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1A56DB)
                  : isPast
                      ? const Color(0xFFF8FAFC)
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1A56DB)
                      : const Color(0xFFE5E9EF)),
            ),
            child: Center(
              child: Text(
                '$dayIndex',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : isPast
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Step 3: Confirm ─────────────────────────────────────────────────────────

  Widget _buildStep3() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final motifCtrl = TextEditingController(text: _data.motif);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _StepTitle(l10n.bookingConfirmTitle),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E9EF)),
          ),
          child: Column(children: [
            _ConfirmRow(
                label: l10n.bookingStepSpecialty,
                value: _data.specialtyName ?? ''),
            _ConfirmRow(
                label: l10n.bookingStepDoctor, value: _data.doctorName ?? ''),
            _ConfirmRow(
                label: l10n.bookingLabelDate,
                value: _data.date != null
                    ? DateFormat('EEEE d MMMM yyyy', locale).format(_data.date!)
                    : ''),
            _ConfirmRow(
                label: l10n.bookingLabelTime, value: _data.timeSlot ?? ''),
            _ConfirmRow(
                label: l10n.bookingLabelDuration,
                value: l10n.bookingDurationValue,
                isLast: true),
          ]),
        ),
        const SizedBox(height: 16),
        Text(l10n.bookingLabelMotif,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
                letterSpacing: .5)),
        const SizedBox(height: 8),
        TextField(
          controller: motifCtrl,
          onChanged: (v) => _data.motif = v,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.bookingHintMotif,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        MsButton(
            label: l10n.bookingActionConfirm,
            loading: _loading,
            onPressed: _confirm),
      ]),
    );
  }
}

// ── Provider for slots (keyed by doctorId + date) ─────────────────────────────

typedef _SlotKey = ({int doctorId, String date});

final _availableSlotsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, _SlotKey>((ref, key) =>
        ref
            .watch(appointmentServiceProvider)
            .getAvailableSlots(key.doctorId, key.date));

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StepTitle extends StatelessWidget {
  final String text;
  const _StepTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 4),
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _ConfirmRow(
      {required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B))),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B))),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ]);
}
