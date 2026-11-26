import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies/core/remote/network/firestore_manager.dart';
import 'package:movies/core/resources/app_theme.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';
import 'package:movies/core/resources/routes_manager.dart';
import 'package:movies/data/model/user_model.dart';

class RegisterScreen extends StatefulWidget {
   const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  late TextEditingController phoneController;
  late ScrollController avatarScrollController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  int selectedAvatarId = 1;

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
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    phoneController = TextEditingController();
    avatarScrollController = ScrollController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    phoneController.dispose();
    avatarScrollController.dispose();
    super.dispose();
  }

  void _selectAvatar(int index) {
    final int avatarId = index + 1;
    setState(() {
      selectedAvatarId = avatarId;
    });

    if (avatarScrollController.hasClients) {
      final double itemExtent = 104.w;
      final double targetOffset =
          (index * itemExtent) - (MediaQuery.of(context).size.width * 0.32);
      avatarScrollController.animateTo(
        targetOffset.clamp(
          0.0,
          avatarScrollController.position.maxScrollExtent,
        ),
        duration:  Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPrefixAssetIcon(String assetPath) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: SvgPicture.asset(
        assetPath,
        width: 24.w,
        height: 24.h,
        colorFilter:  ColorFilter.mode(
          ColorsManager.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'register'.tr(),
          style: AppTheme.appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),

                  SizedBox(
                    height: 132.h,
                    child: ListView.builder(
                      controller: avatarScrollController,
                      scrollDirection: Axis.horizontal,
                      physics:  BouncingScrollPhysics(),
                      itemCount: avatarAssets.length,
                      itemBuilder: (context, index) {
                        final int avatarId = index + 1;
                        final bool isSelected = selectedAvatarId == avatarId;

                        return Center(
                          child: GestureDetector(
                            onTap: () => _selectAvatar(index),
                            child: AnimatedContainer(
                              duration:  Duration(milliseconds: 200),
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              width: isSelected ? 120.w : 84.w,
                              height: isSelected ? 120.h : 84.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                  color: ColorsManager.accentYellow,
                                  width: 2.5.w,
                                )
                                    : null,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  avatarAssets[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'avatar'.tr(),
                      style: AppTheme.bodyRegularStyle,
                    ),
                  ),

                  SizedBox(height: 24.h),

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
                      prefixIcon: _buildPrefixAssetIcon(
                        AssetsManager.identificationIcon,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTheme.bodyRegularStyle,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      final emailRegex =
                      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'please_enter_valid_email'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'email'.tr(),
                      prefixIcon: _buildPrefixAssetIcon(AssetsManager.mailIcon),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: passController,
                    obscureText: !isPasswordVisible,
                    style: AppTheme.bodyRegularStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_password'.tr();
                      }
                      if (value.length < 8) {
                        return 'password_min_length_8'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'password'.tr(),
                      prefixIcon: _buildPrefixAssetIcon(AssetsManager.lockIcon),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: confirmPassController,
                    obscureText: !isConfirmPasswordVisible,
                    style: AppTheme.bodyRegularStyle,
                    validator: (value) {
                      if (value != passController.text) {
                        return 'passwords_dont_match'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'confirm_password'.tr(),
                      prefixIcon: _buildPrefixAssetIcon(AssetsManager.lockIcon),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                            !isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 22.sp,
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
                      prefixIcon:
                      _buildPrefixAssetIcon(AssetsManager.phoneIcon),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (formKey.currentState?.validate() ?? false) {
                        createNewAccount();
                      }
                    },
                    style: AppTheme.primaryButtonStyle,
                    child: isLoading
                        ? SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child:  CircularProgressIndicator(
                        color: ColorsManager.primaryDark,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text('create_account'.tr()),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already_have_account'.tr(),
                        style: AppTheme.bodySmallStyle,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            RoutesManager.loginRoute,
                          );
                        },
                        child: Text(
                          'login'.tr(),
                          style: AppTheme.yellowBoldLinkStyle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryDark,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: ColorsManager.accentYellow,
                          width: 2.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => context.setLocale( Locale('en')),
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: !isArabic
                                    ? ColorsManager.accentYellow
                                    : Colors.transparent,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AssetsManager.usFlagIcon,
                                  width: 26.w,
                                  height: 26.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          GestureDetector(
                            onTap: () => context.setLocale( Locale('ar')),
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isArabic
                                    ? ColorsManager.accentYellow
                                    : Colors.transparent,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AssetsManager.egFlagIcon,
                                  width: 26.w,
                                  height: 26.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credentials =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text,
      );

      final firebaseUser = credentials.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(nameController.text.trim());

        final UserModel user = UserModel(
          id: firebaseUser.uid,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          avatarId: selectedAvatarId,
        );

        FirestoreManager.currentUser = user;

        await FirebaseFirestore.instance
            .collection(UserModel.collectionName)
            .doc(user.id)
            .set(user.toFireStore(), SetOptions(merge: true));
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RoutesManager.mainLayoutRoute);
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: ColorsManager.errorRed,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
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
}