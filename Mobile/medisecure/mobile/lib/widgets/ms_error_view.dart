import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medisecure/l10n/app_localizations.dart';
import '../services/logger_service.dart';

class MsErrorView extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback onRetry;
  const MsErrorView(
      {super.key, required this.error, this.stackTrace, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    log.e('🖥️ UI ERROR displayed', error, stackTrace);
    final msg = error.toString().toLowerCase();
    final l10n = AppLocalizations.of(context)!;

    String label = l10n.errorGeneric;
    IconData icon = Icons.error_outline;

    if (msg.contains('socket') ||
        msg.contains('connection') ||
        msg.contains('host')) {
      label = l10n.errorConnection;
      icon = Icons.wifi_off_rounded;
    } else if (msg.contains('401')) {
      label = l10n.errorSession;
      icon = Icons.lock_clock_outlined;
    } else if (msg.contains('403')) {
      label = l10n.errorForbidden;
      icon = Icons.block_flipped;
    } else if (msg.contains('404')) {
      label = l10n.errorNotFound;
      icon = Icons.search_off_rounded;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.sp, color: const Color(0xFFDC2626)),
            ),
            SizedBox(height: 20.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(160.w, 48.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
