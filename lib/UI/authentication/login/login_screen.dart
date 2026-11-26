import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies/core/remote/network/firestore_manager.dart';
import 'package:movies/core/resources/app_theme.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';
import 'package:movies/core/resources/routes_manager.dart';
import 'package:movies/data/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isLoading = false;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await FirestoreManager.getUser();

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RoutesManager.mainLayoutRoute);
    } on FirebaseAuthException catch (e) {
      String message = 'login_failed'.tr();
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'invalid_email_or_password'.tr();
      } else if (e.code == 'invalid-email') {
        message = 'invalid_email'.tr();
      } else if (e.code == 'network-request-failed') {
        message = 'no_internet'.tr();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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

  Future<void> signInWithGoogle() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final UserModel? user = await FirestoreManager.signInWithGoogle();
      if (user == null) return;

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RoutesManager.mainLayoutRoute);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In Error: ${e.description ?? e.code}'),
          backgroundColor: ColorsManager.errorRed,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed.'),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                Center(
                  child: Image.asset(
                    AssetsManager.appLogo,
                    height: 160.h,
                    width: 160.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.h),
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
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: SvgPicture.asset(
                        AssetsManager.mailIcon,
                        width: 24.w,
                        height: 24.h,
                        colorFilter:  ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: AppTheme.bodyRegularStyle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_password'.tr();
                    }
                    if (value.length < 6) {
                      return 'password_min_length'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'password'.tr(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: SvgPicture.asset(
                        AssetsManager.lockIcon,
                        width: 24.w,
                        height: 24.h,
                        colorFilter:  ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
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
                SizedBox(height: 12.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
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
                      'forget_password'.tr(),
                      style: AppTheme.yellowLinkStyle,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: isLoading ? null : login,
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
                      : Text('login'.tr()),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont_have_account'.tr(),
                      style: AppTheme.bodySmallStyle,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RoutesManager.registerRoute,
                        );
                      },
                      child: Text(
                        'create_one'.tr(),
                        style: AppTheme.yellowBoldLinkStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorsManager.accentYellow,
                        thickness: 1,
                        indent: 40.w,
                        endIndent: 12.w,
                      ),
                    ),
                    Text(
                      'or'.tr(),
                      style: AppTheme.yellowLinkStyle,
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorsManager.accentYellow,
                        thickness: 1,
                        indent: 12.w,
                        endIndent: 40.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                ElevatedButton(
                  onPressed: isLoading ? null : signInWithGoogle,
                  style: AppTheme.googleButtonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsManager.googleIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(width: 12.w),
                      Text('login_with_google'.tr()),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}