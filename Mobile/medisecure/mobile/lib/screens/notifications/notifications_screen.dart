import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _icon(String type) => switch (type) {
        'reminder' => Icons.alarm,
        'confirmation' => Icons.check_circle_outline,
        'cancellation' => Icons.cancel_outlined,
        'prescription' => Icons.medication_outlined,
        _ => Icons.notifications_outlined,
      };

  Color _color(String type) => switch (type) {
        'reminder' => const Color(0xFF1A56DB),
        'confirmation' => const Color(0xFF16A34A),
        'cancellation' => const Color(0xFFDC2626),
        'prescription' => const Color(0xFF7C3AED),
        _ => const Color(0xFF64748B),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications,
            style: TextStyle(fontSize: 18.sp)),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationServiceProvider).markAllRead();
              ref.invalidate(notificationsProvider);
            },
            child: Text(AppLocalizations.of(context)!.notificationsMarkAllRead,
                style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsProvider),
        child: notifAsync.when(
          data: (notifs) {
            if (notifs.isEmpty) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                        child: Icon(Icons.notifications_none_rounded,
                            size: 40.sp, color: const Color(0xFF94A3B8)),
                      ),
                      SizedBox(height: 16.h),
                      Text(AppLocalizations.of(context)!.notificationsEmpty,
                          style: TextStyle(
                              color: const Color(0xFF1E293B),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4.h),
                      Text(AppLocalizations.of(context)!.notificationsEmptySub,
                          style: TextStyle(
                              color: const Color(0xFF64748B), fontSize: 13.sp)),
                    ]),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: notifs.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (_, i) => _NotifTile(
                notif: notifs[i],
                icon: _icon(notifs[i].type),
                color: _color(notifs[i].type),
                onTap: () async {
                  if (notifs[i].isUnread) {
                    await ref
                        .read(notificationServiceProvider)
                        .markRead(notifs[i].id);
                    ref.invalidate(notificationsProvider);
                  }
                },
              ),
            );
          },
          loading: () => const NotificationListSkeleton(),
          error: (e, _) => MsErrorView(
              error: e, onRetry: () => ref.invalidate(notificationsProvider)),
        ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel notif;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _NotifTile(
      {required this.notif,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border(
            left: BorderSide(
              color: notif.isUnread ? color : Colors.transparent,
              width: 3.w,
            ),
            right: const BorderSide(color: Color(0xFFE5E9EF)),
            top: const BorderSide(color: Color(0xFFE5E9EF)),
            bottom: const BorderSide(color: Color(0xFFE5E9EF)),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                if (notif.titre != null)
                  Text(notif.titre!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: notif.isUnread
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF64748B),
                      )),
                SizedBox(height: 3.h),
                Text(notif.message,
                    style: TextStyle(
                        fontSize: 12.sp, color: const Color(0xFF64748B)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 4.h),
                Text(
                    DateFormat('dd MMM HH:mm',
                            Localizations.localeOf(context).languageCode)
                        .format(notif.dateEnvoi),
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600)),
              ])),
          if (notif.isUnread)
            Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(top: 4.h),
                decoration: const BoxDecoration(
                    color: Color(0xFF1A56DB), shape: BoxShape.circle)),
        ]),
      ),
    );
  }
}
