import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';

class Voice extends StatelessWidget {
  const Voice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: tSecondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Iconsax.home),
            title: Text("Home"),
          ),
          ListTile(
            leading: Icon(Iconsax.heart),
            title: Text("Favourites"),
          ),
          ListTile(
            leading: Icon(Iconsax.notification),
            title: Text("Notifications"),
          ),
          ListTile(
            leading: Icon(Iconsax.user),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
