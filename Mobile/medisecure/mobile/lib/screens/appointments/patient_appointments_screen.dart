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

class PatientAppointmentsScreen extends ConsumerStatefulWidget {
  const PatientAppointmentsScreen({super.key});
  @override
  ConsumerState<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState
    extends ConsumerState<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  DateTime _selectedDay = DateTime.now();

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

  List<AppointmentModel> _filter(List<AppointmentModel> all, String status) {
    if (status == 'upcoming') {
      return all
          .where((a) => !a.isCancelled && a.dateRdv.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.dateRdv.compareTo(b.dateRdv));
    }
    if (status == 'past') {
      return all
          .where((a) => a.dateRdv.isBefore(DateTime.now()) || a.isCompleted)
          .toList()
        ..sort((a, b) => b.dateRdv.compareTo(a.dateRdv));
    }
    return all.where((a) => a.isCancelled).toList();
  }

  @override
  Widget build(BuildContext context) {
    final apptAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF1A56DB),
            title: Text(AppLocalizations.of(context)!.navAppointments),
            bottom: TabBar(
              controller: _tabs,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.apptsUpcoming),
                Tab(text: AppLocalizations.of(context)!.apptsPast),
                Tab(text: AppLocalizations.of(context)!.apptsCancelled),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1A56DB),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: _WeekStrip(
                selected: _selectedDay,
                onSelect: (d) => setState(() => _selectedDay = d),
              ),
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () async => ref.invalidate(appointmentsProvider),
          child: apptAsync.when(
            data: (appts) => TabBarView(
              controller: _tabs,
              children: [
                _ApptList(appts: _filter(appts, 'upcoming')),
                _ApptList(appts: _filter(appts, 'past')),
                _ApptList(appts: _filter(appts, 'cancelled')),
              ],
            ),
            loading: () => const AppointmentListSkeleton(),
            error: (e, _) => MsErrorView(
                error: e, onRetry: () => ref.invalidate(appointmentsProvider)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/appointments/book'),
        backgroundColor: const Color(0xFF1A56DB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(AppLocalizations.of(context)!.homeBookAppt,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  const _WeekStrip({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));
    return Row(
      children: days.map((d) {
        final isSelected = d.day == selected.day && d.month == selected.month;
        final isToday = d.day == now.day && d.month == now.month;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : (isToday ? Colors.white24 : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: [
                Text(
                    DateFormat(
                            'E', Localizations.localeOf(context).languageCode)
                        .format(d)
                        .substring(0, 3),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? const Color(0xFF1A56DB) : Colors.white70,
                    )),
                const SizedBox(height: 4),
                Text('${d.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? const Color(0xFF1A56DB) : Colors.white,
                    )),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ApptList extends StatelessWidget {
  final List<AppointmentModel> appts;
  const _ApptList({required this.appts});

  @override
  Widget build(BuildContext context) {
    if (appts.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.event_available_outlined,
              size: 64, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.apptsNone,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => AppointmentCard(
        appointment: appts[i],
        onTap: () => context.push('/appointments/${appts[i].id}'),
      ),
    );
  }
}
