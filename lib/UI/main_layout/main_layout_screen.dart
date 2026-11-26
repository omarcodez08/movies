import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/UI/main_layout/browse/browse_tab.dart';
import 'package:movies/UI/main_layout/home/home_tab.dart';
import 'package:movies/UI/main_layout/profile/profile_tab.dart';
import 'package:movies/UI/main_layout/search/search_tab.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = const [
    HomeTab(),
    SearchTab(),
    BrowseTab(),
    ProfileTab(),
  ];

  Widget _buildNavIcon(String assetPath, int index) {
    final bool isSelected = selectedIndex == index;
    return SvgPicture.asset(
      assetPath,
      width: 24.w,
      height: 24.h,
      colorFilter: ColorFilter.mode(
        isSelected ? ColorsManager.accentYellow : ColorsManager.white,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorsManager.darkGrey,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorsManager.darkGrey,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(AssetsManager.homeIcon, 0),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(AssetsManager.searchIcon, 1),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(AssetsManager.exploreIcon, 2),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(AssetsManager.profileIcon, 3),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}