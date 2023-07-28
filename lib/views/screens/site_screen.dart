import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:provider/provider.dart';

import '../../providers/user_data_provider.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Selector<UserDataProvider, String>(
            selector: (context, provider) => provider.username,
            builder: (context, value, child) {
              return Header(
                title: 'Site',
                subMenu: 'submenu Site',
                userName: value,
              );
            },
          ),
          Text(
            'Site Screen',
            style: themeData.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
