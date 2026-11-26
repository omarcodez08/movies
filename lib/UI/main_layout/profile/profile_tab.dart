import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/remote/network/firestore_manager.dart';
import 'package:movies/core/resources/app_theme.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';
import 'package:movies/core/resources/routes_manager.dart';
import 'package:movies/data/model/user_model.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserModel? user;
  bool isLoadingUser = true;

  final List<String> avatarAssets = [
    AssetsManager.Avatar1,
    AssetsManager.Avatar2,
    AssetsManager.Avatar3,
    AssetsManager.Avatar4,
    AssetsManager.Avatar5,
    AssetsManager.Avatar6,
    AssetsManager.Avatar7,
    AssetsManager.Avatar8,
    AssetsManager.Avatar9,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    UserModel? loadedUser = FirestoreManager.currentUser;
    loadedUser ??= await FirestoreManager.getUser();

    if (!mounted) return;
    setState(() {
      user = loadedUser;
      isLoadingUser = false;
    });
  }

  String _getAvatarAsset(int? avatarId) {
    final int index = ((avatarId ?? 1) - 1).clamp(0, avatarAssets.length - 1);
    return avatarAssets[index];
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    FirestoreManager.currentUser = null;

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      RoutesManager.loginRoute,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = user?.name.isNotEmpty == true
        ? user!.name
        : (FirebaseAuth.instance.currentUser?.displayName ?? 'User');

    return Scaffold(
      backgroundColor: ColorsManager.primaryDark,
      body: isLoadingUser
          ? Center(
        child: CircularProgressIndicator(
          color: ColorsManager.accentYellow,
        ),
      )
          : Column(
        children: [

          Container(
            color: ColorsManager.darkGrey,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            _getAvatarAsset(user?.avatarId),
                            width: 118.w,
                            height: 118.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          width: 130.w,
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildStatColumn(
                      count: 0,
                      label: 'watch_list'.tr(),
                    ),
                    _buildStatColumn(
                      count: 0,
                      label: 'history'.tr(),
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            RoutesManager.editProfileRoute,
                          );
                          _loadUser();
                        },
                        style: AppTheme.primaryButtonStyle.copyWith(
                          minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, 52.h),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        child: Text('edit_profile'.tr()),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.errorRed,
                          foregroundColor: ColorsManager.white,
                          minimumSize: Size(double.infinity, 52.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('exit'.tr()),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.logout_rounded,
                              size: 20.sp,
                              color: ColorsManager.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                TabBar(
                  controller: _tabController,
                  indicatorColor: ColorsManager.accentYellow,
                  indicatorWeight: 3.h,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: ColorsManager.white,
                  unselectedLabelColor: ColorsManager.white,
                  labelStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    Tab(
                      height: 68.h,
                      icon: Icon(
                        Icons.list_rounded,
                        color: ColorsManager.accentYellow,
                        size: 30.sp,
                      ),
                      text: 'watch_list'.tr(),
                    ),
                    Tab(
                      height: 68.h,
                      icon: Icon(
                        Icons.folder_rounded,
                        color: ColorsManager.accentYellow,
                        size: 28.sp,
                      ),
                      text: 'history'.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyPlaceholder(),
                _buildEmptyPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({required int count, required String label}) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: ColorsManager.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            color: ColorsManager.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Image.asset(
        AssetsManager.emptyMovies,
        width: 130.w,
        height: 130.w,
        fit: BoxFit.contain,
      ),
    );
  }
}