// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:innerspace/config/app_preference.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:innerspace/models/onboarding/on_boarding_model.dart';
import 'package:innerspace/screens/onboarding/components/on_boarding_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = LiquidController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pages = [
      OnBoardingWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage1,
          title: tOnBoardingTitle1,
          subtitle: tOnBoardingSubtitle1,
          counterText: tOnBoardingCounter1,
          bgColor: tOnBoardingPage1Color,
          height: size.height,
        ),
      ),
      OnBoardingWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage2,
          title: tOnBoardingTitle2,
          subtitle: tOnBoardingSubtitle2,
          counterText: tOnBoardingCounter2,
          bgColor: tOnBoardingPage2Color,
          height: size.height,
        ),
      ),
      OnBoardingWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage3,
          title: tOnBoardingTitle3,
          subtitle: tOnBoardingSubtitle3,
          counterText: tOnBoardingCounter3,
          bgColor: tOnBoardingPage3Color,
          height: size.height,
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            liquidController: controller,
            onPageChangeCallback: onChangedCallBack,
            pages: pages,
            slideIconWidget: currentPage == pages.length - 1
                ? const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
            enableSideReveal: true,
            fullTransitionValue: 1000,
          ),
          Positioned(
            bottom: 70,
            child: OutlinedButton(
              onPressed: () {
                if (currentPage < pages.length - 1) {
                  controller.animateToPage(
                    page: currentPage + 1,
                    duration: 500,
                  );
                } else {
                  Preference().setOnboarding();
                  Navigator.popAndPushNamed(context, '/welcome');
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(),
                padding: const EdgeInsets.all(5),
                onPrimary: Colors.white,
              ),
              child: Container(
                width: pages.length - 1 == currentPage ? 150 : 100,
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tBlackColor,
                ),
                child: currentPage < pages.length - 1
                    ? const Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                controller.jumpToPage(page: pages.length - 1);
              },
              child: Text(
                currentPage < pages.length - 1 ? 'Skip' : '',
                style: const TextStyle(color: tBlackColor),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: AnimatedSmoothIndicator(
              activeIndex: currentPage,
              count: pages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                dotColor: Colors.grey,
                activeDotColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onChangedCallBack(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
