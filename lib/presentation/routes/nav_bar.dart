import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';
import 'package:innerspace/data/controller/recording/audio_recorder_file_helper.dart';
import 'package:innerspace/presentation/screens/home/home_screen.dart';
import 'package:innerspace/presentation/screens/notifications/notification_screen.dart';
import 'package:innerspace/presentation/screens/profile/profile_screen.dart';
import 'package:innerspace/presentation/screens/search/search_screen.dart';
import 'package:innerspace/presentation/screens/record/record_bottom_sheet.dart';
import 'package:user_repository/data.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.userRepository});
  final UserRepository userRepository;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: tabIndex, children: [
        const HomeScreen(),
        const NotificationScreen(),
        Container(), // Placeholder for the middle button
        const SearchScreen(),
        ProfileScreen(
          userRepository: widget.userRepository,isdarkmode: isDarkMode,
        ),
      ]),
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
            itemBar(Iconsax.notification),
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
        child: Icon(
          Iconsax.microphone4,
          color: isDarkMode ? tWhiteColor : tBlackColor,
          size: 33,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

BottomNavigationBarItem itemBar(IconData icon) {
  return BottomNavigationBarItem(icon: Icon(icon), label: "");
}

void showRecordBottomSheet(BuildContext context) {
  // Create an instance of AudioRecorderController

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return RepositoryProvider<AudioRecorderController>(
        create: (context) => AudioRecorderController(AudioRecorderFileHelper()),
        child: Container(
          child: RecordBottomSheet(),
        ),
      );
    },
  );
}