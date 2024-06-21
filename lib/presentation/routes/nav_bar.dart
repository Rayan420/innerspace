import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/bloc/profile_bloc/profile_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';
import 'package:innerspace/data/controller/recording/audio_recorder_file_helper.dart';
import 'package:innerspace/presentation/screens/home/home_screen.dart';
import 'package:innerspace/presentation/screens/notifications/notification_view.dart';
import 'package:innerspace/presentation/screens/profile/profile_screen.dart';
import 'package:innerspace/presentation/screens/search/search_screen.dart';
import 'package:innerspace/presentation/screens/record/record_bottom_sheet.dart';
import 'package:user_repository/data.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    Key? key,
    required this.userRepository,
    required this.notificationRepository,
  }) : super(key: key);

  final UserRepository userRepository;
  final NotificationRepository notificationRepository;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var tabIndex = 0;
  bool hasNewNotification = false;

  @override
  void initState() {
    super.initState();
    // Listen for new notifications
    widget.notificationRepository.notificationsNotifier.addListener(() {
      final notifications =
          widget.notificationRepository.notificationsNotifier.value;
      if (notifications.isNotEmpty) {
        // Calculate the time difference between now and the first notification's createdAt time
        final firstNotificationTime = notifications.first.createdAt;
        final currentTime = DateTime.now();
        final difference = currentTime.difference(firstNotificationTime);

        // If the time difference is within 30 seconds, consider it a new notification
        if (difference.inSeconds <= 30) {
          // Update hasNewNotification whenever new notifications arrive
          if (mounted) {
            setState(() {
              hasNewNotification = true;
            });
            // Show a top snackbar with notification message
            showNotificationTopSnackbar(context, notifications.first.message);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: [
          const HomeScreen(),
          SearchScreen(
            userRepository: widget.userRepository,
          ),
          Container(),
          NotificationView(
            notificationRepository: widget.notificationRepository,
            userRepository: widget.userRepository,
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              userRepository: widget.userRepository,
            ),
            child: ProfileScreen(
              userRepository: widget.userRepository,
              isdarkmode: isDarkMode,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: isDarkMode ? tBlackColor : tWhiteColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 2.5,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          currentIndex: tabIndex,
          onTap: changeTabIndex,
          selectedItemColor: tPrimaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            itemBar(Iconsax.home4),
            itemBar(Iconsax.search_normal4),
            const BottomNavigationBarItem(
              icon: Icon(
                Iconsax.home,
                color: Colors.transparent,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Iconsax.notification),
                  if (hasNewNotification)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: '',
            ),
            itemBar(Iconsax.user),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: tPrimaryColor,
        onPressed: () {
          showRecordBottomSheet(context);
        },
        child: const Icon(
          Iconsax.microphone4,
          color: tWhiteColor,
          size: 33,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomNavigationBarItem itemBar(IconData icon) {
    return BottomNavigationBarItem(icon: Icon(icon), label: "");
  }

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
      // Reset hasNewNotification when changing tabs
      hasNewNotification = false;
    });
  }

  void showRecordBottomSheet(BuildContext context) {
    // Create an instance of AudioRecorderController
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return RepositoryProvider<AudioRecorderController>(
          create: (context) =>
              AudioRecorderController(AudioRecorderFileHelper()),
          child: const RecordBottomSheet(),
        );
      },
    );
  }

  void showNotificationTopSnackbar(BuildContext context, String message) {
    showTopSnackBar(
      dismissType: DismissType.onSwipe,
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        textStyle: const TextStyle(
          color: tWhiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: tPrimaryColor,
        icon: const Padding(
          padding: EdgeInsets.all(20.0), // Adjust padding as needed
          child: Icon(
            Iconsax.notification5,
            color: tWhiteColor,
          ),
        ),
      ),
      onTap: () {
        // Navigate to the notifications tab when the snackbar is tapped
        changeTabIndex(3);
      },
    );
  }
}
