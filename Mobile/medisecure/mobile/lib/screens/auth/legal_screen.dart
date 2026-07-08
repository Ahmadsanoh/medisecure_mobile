import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1A56DB),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Dernière mise à jour : 16 Avril 2026',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
            Divider(height: 32.h, color: const Color(0xFFE2E8F0)),
            Text(
              content,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF334155),
                height: 1.6,
              ),
            ),
            SizedBox(height: 40.h),
            const Text(
              'Note : Ceci est un document de démonstration.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A56DB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
