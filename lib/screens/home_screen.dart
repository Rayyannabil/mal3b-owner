import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/services/location_service.dart';
import 'package:mal3b/components/card_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  Timer? _timer;
  bool _scrollForward = true;

  final TextEditingController searchController = TextEditingController();
  String _locationText = 'الموقع';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? _userName;
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _loadUserData();
    _determinePosition();
    _startAutoSlide();
    BlocProvider.of<NotificationCubit>(context).saveFCM();
  }

  Future<void> _loadUserData() async {
    _userName = await storage.read(key: "userName") ?? '';
    _userPhone = await storage.read(key: "userPhone") ?? '';
    setState(() {});
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (!_pageController.hasClients) return;

      final nextPage = _pageController.page!.round() + 1;
      if (nextPage < _pageController.positions.first.viewportDimension) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _pageController.dispose();
    _timer?.cancel();
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
            return const Center(
              child: CircularProgressIndicator(color: CustomColors.primary),
            );
          }

          if (state is StadiumAllLoaded) {
            nearest = state.nearestStadiums;
            topRated = state.topRatedStadiums;
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
                                  Navigator.of(context).pushNamed(
                                    '/profile',
                                    arguments: {
                                      'name': _userName ?? '',
                                      'phone': _userPhone ?? '',
                                    },
                                  );
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
                        _buildMainCard(topRated),
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
      padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 15),
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
Widget _buildMainCard(List<dynamic> topRated) {
  if (topRated.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('لا توجد عروض حالياً'),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        SizedBox(
          height: getImageHeight(context),
          child: PageView.builder(
            controller: _pageController,
            itemCount: topRated.length,
            onPageChanged: (index) {
              final isEnd = index == topRated.length - 1;
              final isStart = index == 0;

              // Toggle scroll direction when reaching ends
              if (_scrollForward && isEnd) {
                _scrollForward = false;
              } else if (!_scrollForward && isStart) {
                _scrollForward = true;
              }

              // Add delay before moving to next/previous page
              Future.delayed(Duration(seconds: (isEnd || isStart) ? 3 : 1), () {
                if (!mounted) return;

                if (_scrollForward && index < topRated.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else if (!_scrollForward && index > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
            itemBuilder: (context, index) {
              final item = topRated[index];
              final rating = (item['rating'] is int)
                  ? (item['rating'] as int).toDouble()
                  : (item['rating'] ?? 0.0) as double;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/booking');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/championship.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] ?? 'غير معروف',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${item['price'] ?? "10"} جنيه/الساعة',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SmoothPageIndicator(
                                    controller: _pageController,
                                    count: topRated.length,
                                    effect: WormEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      spacing: 6,
                                      activeDotColor: Colors.white,
                                      dotColor: Colors.white38,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        rating.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Image.asset(
                                        'assets/images/star.png',
                                        width: 18,
                                        height: 18,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
            cardImage: 'assets/images/championship.png',
            cardText: item['name'] ?? 'غير معروف',
            cardPrice: item['price'] ?? '10',
            cardRating: rating,
          );
        }).toList(),
      ),
    );
  }
}
