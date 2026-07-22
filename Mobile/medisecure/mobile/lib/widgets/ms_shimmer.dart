import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// ── Base shimmer box ──────────────────────────────────────────────────────────

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xFFE2E8F0),
        highlightColor: const Color(0xFFF8FAFC),
        child: Container(
          width: width == double.infinity ? double.infinity : width.w,
          height: height.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
      );
}

// ── Appointment card skeleton ─────────────────────────────────────────────────

class AppointmentCardSkeleton extends StatelessWidget {
  const AppointmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E9EF)),
        ),
        child: const Row(children: [
          Column(children: [
            ShimmerBox(width: 44, height: 16),
            SizedBox(height: 4),
            ShimmerBox(width: 28, height: 10),
          ]),
          SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ShimmerBox(height: 14),
              SizedBox(height: 6),
              ShimmerBox(width: 120, height: 12),
              SizedBox(height: 4),
              ShimmerBox(width: 80, height: 10),
            ]),
          ),
          SizedBox(width: 8),
          ShimmerBox(width: 60, height: 24, radius: 12),
        ]),
      );
}

class AppointmentListSkeleton extends StatelessWidget {
  final int count;
  const AppointmentListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++) ...[
              const AppointmentCardSkeleton(),
              if (i < count - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      );
}

// ── Notification item skeleton ────────────────────────────────────────────────

class NotificationItemSkeleton extends StatelessWidget {
  const NotificationItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          ShimmerBox(width: 40, height: 40, radius: 20),
          SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ShimmerBox(height: 13),
              SizedBox(height: 6),
              ShimmerBox(width: 160, height: 11),
            ]),
          ),
          SizedBox(width: 8),
          ShimmerBox(width: 36, height: 10),
        ]),
      );
}

class NotificationListSkeleton extends StatelessWidget {
  final int count;
  const NotificationListSkeleton({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            const NotificationItemSkeleton(),
            if (i < count - 1)
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ],
        ],
      );
}

// ── Medical record skeleton ───────────────────────────────────────────────────

class RecordSectionSkeleton extends StatelessWidget {
  const RecordSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ShimmerBox(width: 120, height: 14),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E9EF)),
            ),
            child: const Column(children: [
              ShimmerBox(height: 13),
              SizedBox(height: 8),
              ShimmerBox(height: 13),
              SizedBox(height: 8),
              ShimmerBox(width: 200, height: 13),
            ]),
          ),
        ]),
      );
}

// ── Home stats skeleton ───────────────────────────────────────────────────────

// ── Home stats skeleton ───────────────────────────────────────────────────────

class HomeStatsSkeleton extends StatelessWidget {
  const HomeStatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 0; i < 3; i++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E9EF)),
              ),
              child: const Column(children: [
                ShimmerBox(width: 32, height: 32, radius: 10),
                SizedBox(height: 8),
                ShimmerBox(width: 40, height: 18),
                SizedBox(height: 4),
                ShimmerBox(width: 56, height: 10),
              ]),
            ),
          ),
          if (i < 2) const SizedBox(width: 10),
        ],
      ]);
}

// ── Patient item skeleton ───────────────────────────────────────────────────

class PatientItemSkeleton extends StatelessWidget {
  const PatientItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: [
            ShimmerBox(width: 40, height: 40, radius: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 14),
                  SizedBox(height: 6),
                  ShimmerBox(width: 160, height: 11),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
          ]),
        ),
      );
}

class PatientListSkeleton extends StatelessWidget {
  const PatientListSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, __) => const PatientItemSkeleton(),
      );
}

// ── Slot grid skeleton ──────────────────────────────────────────────────────

class SlotGridSkeleton extends StatelessWidget {
  const SlotGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 9; i++) const ShimmerBox(height: 40, radius: 10),
        ],
      );
}

// ── Profile skeleton ────────────────────────────────────────────────────────

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: const Column(children: [
              ShimmerBox(width: 80, height: 80, radius: 40),
              SizedBox(height: 16),
              ShimmerBox(width: 150, height: 18),
              SizedBox(height: 8),
              ShimmerBox(width: 100, height: 12),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              for (var i = 0; i < 4; i++) ...[
                const ShimmerBox(height: 60, radius: 12),
                const SizedBox(height: 12),
              ],
            ]),
          ),
        ]),
      );
}
