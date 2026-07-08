// ── MsButton ──────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/logger_service.dart';

class MsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final EdgeInsets? padding;

  const MsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: (loading || onPressed == null)
                ? null
                : () {
                    log.i('Bouton cliqué: "$label"');
                    onPressed!();
                  },
            child: loading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5.w, color: Colors.white))
                : Text(label, style: TextStyle(fontSize: 15.sp)),
          ),
        ),
      );
}
