import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:mal3b/services/location_service.dart';
import 'package:mal3b/components/card_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String _locationText = 'الموقع';

  @override
  void initState() {
    super.initState();
    // sendOTP("+201125437521");
    _determinePosition();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  int? resendToken;
  Future<void> sendOTP(String phoneNumber, {bool isResend = false}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: isResend ? resendToken : null,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optional: Auto-sign in if SMS auto-detected
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Error: ${e.message}');
      },
      codeSent: (String verId, int? newToken) {
        verificationId = verId;
        resendToken = newToken;
        print('OTP sent!');
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      String address = await LocationService().determinePosition();
      setState(() {
        _locationText = address;
      });

      final location = await LocationService().getLongAndLat();
      context.read<StadiumCubit>().fetchAllData(
        location.latitude,
        location.longitude,
      );
    } catch (e) {
      log('Error determining position: $e');
      setState(() {
        _locationText = 'الموقع غير معروف';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<StadiumCubit, StadiumState>(
        builder: (context, state) {
          List<dynamic> nearest = [];
          List<dynamic> topRated = [];

          if (state is StadiumLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StadiumLoaded) {
            log(state.stadiums.toString());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 110,
                        width: getProfileImageWidth(context) * 1.35,
                        decoration: const BoxDecoration(
                          color: CustomColors.primary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/profile');
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profile.jpg',
                                    height: getIconWidth(context) * 1.75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed('/notifications');
                                },
                                child: SvgPicture.asset(
                                  "assets/images/notification.svg",
                                  width: getIconWidth(context),
                                  height: getIconWidth(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getHorizontalSpace(context, 10)),
                    Expanded(
                      child: SizedBox(
                        height: 110,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: CustomColors.customWhite,
                              ),
                              height: getVerticalSpace(context, 39),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    _locationText,
                                    style: TextStyle(
                                      color: CustomColors.secondary.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getVerticalSpace(context, 60)),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle('عروض'),
                        _buildMainCard(),
                        SizedBox(height: getVerticalSpace(context, 50)),
                        _buildTitle('الأفضل'),
                        _buildCardList(topRated),
                        SizedBox(height: getVerticalSpace(context, 50)),
                        _buildTitle('الأقرب'),
                        _buildCardList(nearest),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: CustomColors.secondary,
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/booking');
        },
        child: Container(
          width: double.infinity,
          height: getImageHeight(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: AssetImage('assets/images/championship.png'),
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
                padding: const EdgeInsetsDirectional.only(end: 20, start: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getVerticalSpace(context, 39)),
                    const Text(
                      'القاهرة',
                      style: TextStyle(
                        fontSize: 24,
                        color: CustomColors.customWhite,
                      ),
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
                      style: TextStyle(color: CustomColors.customWhite),
                    ),
                    SizedBox(width: getHorizontalSpace(context, 5)),
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
    );
  }

  Widget _buildCardList(List<dynamic> items) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('لا توجد بيانات حالياً'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final rating = (item['rating'] is int)
              ? (item['rating'] as int).toDouble()
              : (item['rating'] ?? 0.0) as double;

          return CardComponent(
            cardImage: item['image'] ?? 'assets/images/championship.png',
            cardText: item['name'] ?? 'غير معروف',
            cardPrice: item['price'],
            cardRating: rating,
          );
        }).toList(),
      ),
    );
  }
}
