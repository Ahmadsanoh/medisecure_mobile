import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/appointment_service.dart';
import '../../models/appointment_model.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';
import '../../widgets/section_header.dart';

class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentsScreen({super.key});
  @override
  ConsumerState<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState
    extends ConsumerState<DoctorAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<AppointmentModel> _filter(List<AppointmentModel> all, String category) {
    if (category == 'today') {
      return all
          .where((a) =>
              a.dateRdv.year == _selectedDate.year &&
              a.dateRdv.month == _selectedDate.month &&
              a.dateRdv.day == _selectedDate.day)
          .toList()
        ..sort((a, b) => a.dateRdv.compareTo(b.dateRdv));
    }
    if (category == 'pending') {
      return all.where((a) => a.isPending).toList()
        ..sort((a, b) => a.dateRdv.compareTo(b.dateRdv));
    }
    return all.where((a) => a.isConfirmed || a.isCompleted).toList()
      ..sort((a, b) => b.dateRdv.compareTo(a.dateRdv));
  }

  @override
  Widget build(BuildContext context) {
    final apptAsync = ref.watch(appointmentsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.navAppointments),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: "Aujourd'hui"), // Needs l10n keys if strict
            Tab(text: "En attente"),
            Tab(text: "Historique"),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(appointmentsProvider),
        child: apptAsync.when(
          data: (appts) => TabBarView(
            controller: _tabs,
            children: [
              _DoctorApptList(
                appts: _filter(appts, 'today'),
                title:
                    "Planning du ${DateFormat('dd MMMM', Localizations.localeOf(context).languageCode).format(_selectedDate)}",
                showPicker: true,
                onDateChange: (d) => setState(() => _selectedDate = d),
              ),
              _DoctorApptList(
                appts: _filter(appts, 'pending'),
                title: "Demandes à valider",
              ),
              _DoctorApptList(
                appts: _filter(appts, 'history'),
                title: "Consultations passées",
              ),
            ],
          ),
          loading: () => const AppointmentListSkeleton(),
          error: (e, _) => MsErrorView(
              error: e, onRetry: () => ref.invalidate(appointmentsProvider)),
        ),
      ),
    );
  }
}

class _DoctorApptList extends StatelessWidget {
  final List<AppointmentModel> appts;
  final String title;
  final bool showPicker;
  final ValueChanged<DateTime>? onDateChange;

  const _DoctorApptList({
    required this.appts,
    required this.title,
    this.showPicker = false,
    this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: SectionHeader(title: title)),
            if (showPicker)
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) onDateChange?.call(d);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (appts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.event_note_outlined,
                      size: 48, color: Color(0xFFCBD5E1)),
                  SizedBox(height: 12),
                  Text("Aucun rendez-vous trouvé",
                      style: TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          )
        else
          ...appts.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppointmentCard(
                  appointment: a,
                  onTap: () => context.push('/appointments/${a.id}'),
                ),
              )),
      ],
    );
  }
}
