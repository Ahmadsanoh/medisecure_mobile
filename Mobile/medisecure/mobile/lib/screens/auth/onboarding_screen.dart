import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/setup_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Dossier Médical Sécurisé',
      description:
          'Accédez à votre historique médical complet, vos ordonnances et vos résultats d\'examens en toute sécurité.',
      icon: Icons.security_rounded,
      color: const Color(0xFF1A56DB),
    ),
    OnboardingData(
      title: 'Prise de Rendez-vous Simple',
      description:
          'Réservez vos consultations avec vos médecins en quelques clics, 24h/24 et 7j/7.',
      icon: Icons.calendar_month_rounded,
      color: const Color(0xFF0D9488),
    ),
    OnboardingData(
      title: 'Suivi en Temps Réel',
      description:
          'Recevez des notifications pour vos rendez-vous et suivez l\'évolution de vos constantes vitales.',
      icon: Icons.insights_rounded,
      color: const Color(0xFF7C3AED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(40.r),
                      decoration: BoxDecoration(
                        color: page.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        page.icon,
                        size: 100.sp,
                        color: page.color,
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 60.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: _currentPage == index ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: () => _finishOnboarding(),
                          child: Text(
                            'Passer',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finishOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage].color,
                          minimumSize: Size(
                              _currentPage == _pages.length - 1 ? 200.w : 60.w,
                              56.h),
                        ),
                        child: _currentPage == _pages.length - 1
                            ? Text('Commencer')
                            : const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go('/login');
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
