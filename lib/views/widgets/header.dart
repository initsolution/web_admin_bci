import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/theme/theme.dart';

class Header extends StatelessWidget {
  final String title;
  final String subMenu;
  const Header({super.key, required this.title, required this.subMenu});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: themeData.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subMenu,
                  style: themeData.textTheme.headlineSmall,
                ),
              ],
            ),
            const Spacer(),
            const ProfileCard(),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.jpg",
            height: 38,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Text(
                "admin@gmail.com",
                style: TextStyle(color: Colors.white),
              )),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
