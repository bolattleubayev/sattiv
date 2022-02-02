import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Icon-120.png',
            fit: BoxFit.scaleDown,
            height: kToolbarHeight - 5,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            "SattiV",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
