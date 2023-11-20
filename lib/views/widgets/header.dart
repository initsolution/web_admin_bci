import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';

class Header extends StatelessWidget {
  final String title;
  final String subMenu;
  const Header({super.key, required this.title, required this.subMenu});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding, bottom: kDefaultPadding/2),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: themeData.textTheme.headlineSmall,
              ),
              // const SizedBox(height: 4),
              // Text(
              //   subMenu,
              //   style: themeData.textTheme.titleMedium,
              // ),
            ],
          ),
          // const Spacer(),
          // ProfileCard(userName, context),
        ],
      ),
    );
  }

  // Widget ProfileCard(String userName, BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return SizedBox(child: DialogProfileEmployee());
  //         },
  //       );
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(left: kDefaultPadding),
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: kDefaultPadding / 3,
  //         vertical: kDefaultPadding / 2,
  //       ),
  //       decoration: BoxDecoration(
  //         color: kPrimaryColor,
  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
  //         border: Border.all(color: Colors.white),
  //       ),
  //       child: Row(
  //         children: [
  //           Image.asset(
  //             "assets/images/ic_profile.png",
  //             height: 38,
  //           ),
  //           Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
  //               child: Text(
  //                 userName,
  //                 style: const TextStyle(color: Colors.white),
  //               )),
  //           const Icon(
  //             Icons.keyboard_arrow_down,
  //             color: Colors.white,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
