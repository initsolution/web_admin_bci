import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/master_layout_config.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_sidebar_theme.dart';
import 'package:go_router/go_router.dart';

class SidebarMenuConfig {
  final String uri;
  final IconData icon;
  final String Function(BuildContext context) title;
  final List<SidebarChildMenuConfig> children;

  const SidebarMenuConfig({
    required this.uri,
    required this.icon,
    required this.title,
    List<SidebarChildMenuConfig>? children,
  }) : children = children ?? const [];
}

class SidebarChildMenuConfig {
  final String uri;
  final IconData icon;
  final String Function(BuildContext context) title;

  const SidebarChildMenuConfig({
    required this.uri,
    required this.icon,
    required this.title,
  });
}

class Sidebar extends ConsumerStatefulWidget {
  final bool autoSelectMenu;
  final String? selectedMenuUri;
  final void Function() onAccountButtonPressed;
  final void Function() onLogoutButtonPressed;
  final List<SidebarMenuConfig> sidebarConfigs;

  const Sidebar({
    Key? key,
    this.autoSelectMenu = true,
    this.selectedMenuUri,
    required this.onAccountButtonPressed,
    required this.onLogoutButtonPressed,
    required this.sidebarConfigs,
  }) : super(key: key);

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final lang = Lang.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final themeData = Theme.of(context);
    final sidebarTheme = themeData.extension<AppSidebarTheme>()!;

    return Drawer(
      child: Column(
        children: [
          Visibility(
            visible: (mediaQueryData.size.width <= kScreenWidthLg),
            child: Container(
              alignment: Alignment.centerLeft,
              height: kToolbarHeight,
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                onPressed: () {
                  if (Scaffold.of(context).isDrawerOpen) {
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(Icons.close_rounded),
                color: sidebarTheme.foregroundColor,
                tooltip: 'Close Navigation Menu',
              ),
            ),
          ),
          Expanded(
            child: Theme(
              data: themeData.copyWith(
                scrollbarTheme: themeData.scrollbarTheme.copyWith(
                  thumbColor: MaterialStateProperty.all(
                      sidebarTheme.foregroundColor.withOpacity(0.2)),
                ),
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    sidebarTheme.sidebarLeftPadding,
                    sidebarTheme.sidebarTopPadding,
                    sidebarTheme.sidebarRightPadding,
                    sidebarTheme.sidebarBottomPadding,
                  ),
                  children: [
                    SidebarHeader(
                      onAccountButtonPressed: widget.onAccountButtonPressed,
                      onLogoutButtonPressed: widget.onLogoutButtonPressed,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        height: 2.0,
                        thickness: 1.0,
                        color: sidebarTheme.foregroundColor.withOpacity(0.5),
                      ),
                    ),
                    _sidebarMenuList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarMenuList(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;

    var currentLocation = widget.selectedMenuUri ?? '';

    if (currentLocation.isEmpty && widget.autoSelectMenu) {
      currentLocation = GoRouter.of(context).location;
    }
    var data = 1;

    return Column(
      children: data == 0
          ? sidebarMenuConfigs.map<Widget>((menu) {
              if (menu.children.isEmpty) {
                return _sidebarMenu(
                  context,
                  EdgeInsets.fromLTRB(
                    sidebarTheme.menuLeftPadding,
                    sidebarTheme.menuTopPadding,
                    sidebarTheme.menuRightPadding,
                    sidebarTheme.menuBottomPadding,
                  ),
                  menu.uri,
                  menu.icon,
                  menu.title(context),
                  (currentLocation.startsWith(menu.uri)),
                );
              } else {
                return _expandableSidebarMenu(
                  context,
                  EdgeInsets.fromLTRB(
                    sidebarTheme.menuLeftPadding,
                    sidebarTheme.menuTopPadding,
                    sidebarTheme.menuRightPadding,
                    sidebarTheme.menuBottomPadding,
                  ),
                  menu.uri,
                  menu.icon,
                  menu.title(context),
                  menu.children,
                  currentLocation,
                );
              }
            }).toList(growable: false)
          : sidebarMenuConfigs.map<Widget>((menu) {
              if (menu.children.isEmpty) {
                return _sidebarMenu(
                  context,
                  EdgeInsets.fromLTRB(
                    sidebarTheme.menuLeftPadding,
                    sidebarTheme.menuTopPadding,
                    sidebarTheme.menuRightPadding,
                    sidebarTheme.menuBottomPadding,
                  ),
                  menu.uri,
                  menu.icon,
                  menu.title(context),
                  (currentLocation.startsWith(menu.uri)),
                );
              } else {
                return _expandableSidebarMenu(
                  context,
                  EdgeInsets.fromLTRB(
                    sidebarTheme.menuLeftPadding,
                    sidebarTheme.menuTopPadding,
                    sidebarTheme.menuRightPadding,
                    sidebarTheme.menuBottomPadding,
                  ),
                  menu.uri,
                  menu.icon,
                  menu.title(context),
                  menu.children,
                  currentLocation,
                );
              }
            }).toList(growable: false),
    );
  }

  Widget _sidebarMenu(
    BuildContext context,
    EdgeInsets padding,
    String uri,
    IconData icon,
    String title,
    bool isSelected,
  ) {
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;
    final textColor = (isSelected
        ? sidebarTheme.menuSelectedFontColor
        : sidebarTheme.foregroundColor);

    return Padding(
      padding: padding,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sidebarTheme.menuBorderRadius)),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: (sidebarTheme.menuFontSize + 4.0),
                color: textColor,
              ),
              const SizedBox(width: kDefaultPadding * 0.5),
              Text(
                title,
                style: TextStyle(
                  fontSize: sidebarTheme.menuFontSize,
                  color: textColor,
                ),
              ),
            ],
          ),
          onTap: () {
            ref.read(employeeNotifierProvider.notifier).getAllEmployee();
            GoRouter.of(context).go(uri);
          },
          selected: isSelected,
          selectedTileColor: sidebarTheme.menuSelectedBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(sidebarTheme.menuBorderRadius)),
          textColor: textColor,
          hoverColor: sidebarTheme.menuHoverColor,
        ),
      ),
    );
  }

  Widget _expandableSidebarMenu(
    BuildContext context,
    EdgeInsets padding,
    String uri,
    IconData icon,
    String title,
    List<SidebarChildMenuConfig> children,
    String currentLocation,
  ) {
    final themeData = Theme.of(context);
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;
    final hasSelectedChild =
        children.any((e) => currentLocation.startsWith(e.uri));
    final parentTextColor = (hasSelectedChild
        ? sidebarTheme.menuSelectedFontColor
        : sidebarTheme.foregroundColor);

    return Padding(
      padding: padding,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sidebarTheme.menuBorderRadius)),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: themeData.copyWith(
            hoverColor: sidebarTheme.menuExpandedHoverColor,
          ),
          child: ExpansionTile(
            key: UniqueKey(),
            textColor: parentTextColor,
            collapsedTextColor: parentTextColor,
            iconColor: parentTextColor,
            collapsedIconColor: parentTextColor,
            backgroundColor: sidebarTheme.menuExpandedBackgroundColor,
            collapsedBackgroundColor: (hasSelectedChild
                ? sidebarTheme.menuExpandedBackgroundColor
                : Colors.transparent),
            initiallyExpanded: hasSelectedChild,
            childrenPadding: EdgeInsets.only(
              top: sidebarTheme.menuExpandedChildTopPadding,
              bottom: sidebarTheme.menuExpandedChildBottomPadding,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: (sidebarTheme.menuFontSize + 4.0),
                ),
                const SizedBox(width: kDefaultPadding * 0.5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sidebarTheme.menuFontSize,
                  ),
                ),
              ],
            ),
            children: children.map<Widget>((childMenu) {
              return _sidebarMenu(
                context,
                EdgeInsets.fromLTRB(
                  sidebarTheme.menuExpandedChildLeftPadding,
                  sidebarTheme.menuExpandedChildTopPadding,
                  sidebarTheme.menuExpandedChildRightPadding,
                  sidebarTheme.menuExpandedChildBottomPadding,
                ),
                childMenu.uri,
                childMenu.icon,
                childMenu.title(context),
                (currentLocation.startsWith(childMenu.uri)),
              );
            }).toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class SidebarHeader extends ConsumerWidget {
  final void Function() onAccountButtonPressed;
  final void Function() onLogoutButtonPressed;

  const SidebarHeader({
    Key? key,
    required this.onAccountButtonPressed,
    required this.onLogoutButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final sidebarTheme = themeData.extension<AppSidebarTheme>()!;
    var value = ref.watch(userDataProvider.select((value) => value.username));

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset("assets/hospital_ic.png"),
              ),
            ),
            const SizedBox(width: kDefaultPadding * 0.5),
            Text(
              'Hi, $value',
              style: TextStyle(
                fontSize: sidebarTheme.headerUsernameFontSize,
                color: sidebarTheme.foregroundColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: kDefaultPadding * 0.5),
        Align(
          alignment: Alignment.centerRight,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textButton(themeData, sidebarTheme, Icons.login_rounded,
                    'Logout', onLogoutButtonPressed),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _textButton(ThemeData themeData, AppSidebarTheme sidebarTheme,
      IconData icon, String text, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: sidebarTheme.foregroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: (sidebarTheme.headerUsernameFontSize + 4.0),
          ),
          const SizedBox(width: kDefaultPadding * 0.5),
          Text(
            text,
            style: TextStyle(
              fontSize: sidebarTheme.headerUsernameFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
