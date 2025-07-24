import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/models/user_profile_model.dart';
import 'package:mal3b/screens/profile_screen_skip.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String phone;

  const ProfileScreen({super.key, required this.name, required this.phone});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfileModel userProfileModel;
  @override
  void initState() {
    context.read<AuthenticationCubit>().getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {},
      builder: (context, state) => state is AccountDetailsLoading
          ? Center(
              child: CircularProgressIndicator(color: CustomColors.primary),
            )
          : state is AccountDetailsGotSuccessfully
          ? Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: getVerticalSpace(context, 20)),
                      SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 20,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: CustomColors.primary,
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(width: getHorizontalSpace(context, 110)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'assets/images/profile.jpg',
                                width: 100,
                                height: 100,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'حسابي',
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            end: 20,
                            top: 25,
                            bottom: 10,
                          ),
                          child: Text(
                            'آخر الملاعب',
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          height: getImageHeight(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/championship.png',
                              ),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 20,
                                  start: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: getVerticalSpace(context, 39),
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          'القاهرة',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: CustomColors.customWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      '300 جنيه / الساعة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.customWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  end: 20,
                                  top: 40,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '4.5',
                                      style: TextStyle(
                                        color: CustomColors.customWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: getHorizontalSpace(context, 5),
                                    ),
                                    Image.asset(
                                      'assets/images/star.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: 35,
                            bottom: 15,
                            start: 20,
                            end: 20,
                          ),
                          child: Text(
                            'معلومات الحساب',
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      // name
                      SizedBox(
                        height: getVerticalSpace(context, 55),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 26,
                                end: 15,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/user.svg',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            Text(state.user.name),
                          ],
                        ),
                      ),
                      Divider(indent: 30, endIndent: 30, color: Colors.grey),
                      // phone
                      SizedBox(
                        height: getVerticalSpace(context, 55),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 26,
                                end: 15,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/phone.svg',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            Text(state.user.phone),
                          ],
                        ),
                      ),
                      Divider(indent: 30, endIndent: 30, color: Colors.grey),
                      // location (ثابتة حالياً)
                      SizedBox(
                        height: getVerticalSpace(context, 55),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 26,
                                end: 15,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/location.svg',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            const Text('الإسكندرية'),
                          ],
                        ),
                      ),
                      Divider(indent: 30, endIndent: 30, color: Colors.grey),
                      // edit data
                      SizedBox(
                        height: getVerticalSpace(context, 55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/edit-profile',
                                  arguments: {
                                    'name': widget.name,
                                    'phone': widget.phone,
                                  },
                                );
                              },
                              child: Text(
                                'تعديل البيانات',
                                style: TextStyle(color: CustomColors.primary),
                              ),
                            ),
                            SizedBox(width: getVerticalSpace(context, 75)),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 26,
                                end: 15,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/edit.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(indent: 30, endIndent: 30, color: Colors.grey),
                      // log out
                      SizedBox(
                        height: getVerticalSpace(context, 55),
                        child: GestureDetector(
                          onTap: () async {
                            await context.read<AuthenticationCubit>().logout();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'تسجيل الخروج',
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(width: getVerticalSpace(context, 75)),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 26,
                                  end: 15,
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/logout.svg',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ProfileScreenSkip(),
    );
  }
}
