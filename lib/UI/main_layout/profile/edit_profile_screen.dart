import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/remote/network/firestore_manager.dart';
import 'package:movies/core/resources/app_theme.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';
import 'package:movies/core/resources/routes_manager.dart';
import 'package:movies/data/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int selectedAvatarId = 1;
  bool isLoading = false;

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
    final UserModel? user = FirestoreManager.currentUser;
    nameController.text =
        user?.name ?? FirebaseAuth.instance.currentUser?.displayName ?? '';
    phoneController.text = user?.phone ?? '';
    selectedAvatarId = (user?.avatarId ?? 1).clamp(1, avatarAssets.length);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String _getAvatarAsset(int avatarId) {
    final int index = (avatarId - 1).clamp(0, avatarAssets.length - 1);
    return avatarAssets[index];
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: ColorsManager.darkGrey,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: avatarAssets.length,
            itemBuilder: (context, index) {
              final int avatarId = index + 1;
              final bool isSelected = selectedAvatarId == avatarId;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatarId = avatarId;
                  });
                  Navigator.of(sheetContext).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsManager.accentYellow.withValues(alpha: 0.45)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: ColorsManager.accentYellow,
                      width: 1.5.w,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      avatarAssets[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final String updatedName = nameController.text.trim();
      final String updatedPhone = phoneController.text.trim();

      await firebaseUser.updateDisplayName(updatedName);

      final UserModel updatedUser = UserModel(
        id: firebaseUser.uid,
        name: updatedName,
        email: FirestoreManager.currentUser?.email ?? firebaseUser.email ?? '',
        phone: updatedPhone,
        avatarId: selectedAvatarId,
      );

      await FirestoreManager.addUser(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('profile_updated'.tr()),
          backgroundColor: ColorsManager.accentYellow,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'error'.tr()}: $e'),
          backgroundColor: ColorsManager.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final String uid = firebaseUser.uid;
      await firebaseUser.delete();
      await FirebaseFirestore.instance
          .collection(UserModel.collectionName)
          .doc(uid)
          .delete();

      FirestoreManager.currentUser = null;

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesManager.loginRoute,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'delete_account_failed'.tr()),
          backgroundColor: ColorsManager.errorRed,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'error'.tr()}: $e'),
          backgroundColor: ColorsManager.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pick_avatar'.tr(),
          style: AppTheme.appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32.h,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12.h),


                        Center(
                          child: GestureDetector(
                            onTap: _showAvatarPicker,
                            child: ClipOval(
                              child: Image.asset(
                                _getAvatarAsset(selectedAvatarId),
                                width: 150.w,
                                height: 150.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),


                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          style: AppTheme.bodyRegularStyle,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please_enter_name'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'name'.tr(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(14.w),
                              child: SvgPicture.asset(
                                AssetsManager.user,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTheme.bodyRegularStyle,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please_enter_phone'.tr();
                            }
                            if (value.trim().length < 10) {
                              return 'invalid_phone_number'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'phone_number'.tr(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(14.w),
                              child: SvgPicture.asset(
                                AssetsManager.phoneIcon,
                                width: 24.w,
                                height: 24.h,
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 20.h),


                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                RoutesManager.forgetPasswordRoute,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'reset_password'.tr(),
                              style: TextStyle(
                                color: ColorsManager.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                         Spacer(),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: isLoading ? null : _deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.errorRed,
                            foregroundColor: ColorsManager.white,
                            minimumSize: Size(double.infinity, 55.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text('delete_account'.tr()),
                        ),

                        SizedBox(height: 16.h),

                        ElevatedButton(
                          onPressed: isLoading ? null : _updateProfile,
                          style: AppTheme.primaryButtonStyle,
                          child: isLoading
                              ? SizedBox(
                            height: 24.h,
                            width: 24.h,
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryDark,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text('update_data'.tr()),
                        ),

                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}