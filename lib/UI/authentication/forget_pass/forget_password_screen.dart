import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies/core/resources/app_theme.dart';
import 'package:movies/core/resources/assets_manager.dart';
import 'package:movies/core/resources/colors_manager.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('reset_link_sent'.tr()),
          backgroundColor: ColorsManager.accentYellow,
        ),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message = 'reset_password_failed'.tr();
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = 'no_user_found_for_email'.tr();
      } else if (e.code == 'invalid-email') {
        message = 'please_enter_valid_email'.tr();
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
          'forget_password_title'.tr(),
          style: AppTheme.appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: Image.asset(
                    AssetsManager.forgotPass,
                    height: 400.h,
                    width: 400.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 36.h),
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
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
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
                      : Text('verify_email'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}