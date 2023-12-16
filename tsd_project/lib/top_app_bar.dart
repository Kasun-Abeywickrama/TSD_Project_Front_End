import 'package:flutter/material.dart';

class CustomTopAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<CustomTopAppBar> createState() => _CustomTopAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomTopAppBarState extends State<CustomTopAppBar> {
  void onImageClick() {
    // Add your desired action here
    print('Image clicked!');
    // You can navigate to another screen, show a dialog, etc.
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(''),
      leading: Container(
        padding: const EdgeInsets.only(left: 5.0),
        width: double.infinity,
        child: GestureDetector(
          onTap: onImageClick,
          child: const CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/profile_img.png'), // Provide the path to your image asset
          ),
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                size: 40.0,
                color: Color(0xFF573926),
              ),
              onPressed: () {
                print('Notification icon tapped!');
              },
            ),
            const Positioned(
              right: 5.0,
              top: 5.0,
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 11.0,
                child: Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
