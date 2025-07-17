import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:mal3b/services/location_service.dart';
import 'package:mal3b/components/card_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String _locationText = 'الموقع'; // Default text for location

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Call location service when the screen initializes
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Method to determine the current position
  Future<void> _determinePosition() async {
    try {
      String address = await LocationService().determinePosition();
      setState(() {
        _locationText = address;
      });
    } catch (e) {
      setState(() {
        _locationText = 'خطأ: ${e.toString()}';
      });
      // Toast messages are now handled within LocationService
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // profile and notifications
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profile.jpg',
                                height: getIconWidth(context) * 1.75,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          SvgPicture.asset(
                            "assets/images/notification.svg",
                            fit: BoxFit.contain,
                            width: getIconWidth(context),
                            height: getIconWidth(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getHorizontalSpace(context, 10)),
                // location
                Expanded(
                  child: SizedBox(
                    height: 110,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: CustomColors.customWhite,
                          ),
                          height: getVerticalSpace(context, 39),
                          child: Center(
                            child: Text(
                              _locationText, // Display fetched location or status

                              style: TextStyle(
                                color: CustomColors.secondary.withOpacity(0.5),
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

          // offers and content
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align to the right
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 29,
                        start: 29,
                      ),
                      child: Text(
                        'عروض',
                        // textAlign: TextAlign.right, // Explicitly right align
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.secondary,
                        ),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 10)),

                    // main card - cairo
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        height: getImageHeight(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage('assets/images/championship.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // rating
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
                                  Text(
                                    'القاهرة',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: CustomColors.customWhite,
                                    ),
                                  ),
                                  Text(
                                    '300 جنيه / الساعة',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CustomColors.customWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 20,
                                    end: 20,
                                    top: 40,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
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
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: getVerticalSpace(context, 50)),

                    // best content
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 29,
                        start: 29,
                      ),
                      child: Text(
                        'الأفضل',
                        textAlign: TextAlign.right, // Explicitly right align
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.secondary,
                        ),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 10)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'القاهرة',
                            cardPrice: '200',
                            cardRating: '4.5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'الإسكندرية',
                            cardPrice: '300',
                            cardRating: '4.7',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'البحيرة',
                            cardPrice: '2300',
                            cardRating: '5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'كفر الدوار',
                            cardPrice: '123',
                            cardRating: '4',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'العصافرة',
                            cardPrice: '123',
                            cardRating: '5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'الحجر',
                            cardPrice: '200',
                            cardRating: '4',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 50)),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 29,
                        start: 29,
                      ),
                      child: Text(
                        'الأقرب',
                        textAlign: TextAlign.right, // Explicitly right align
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.secondary,
                        ),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 10)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'القاهرة',
                            cardPrice: '200',
                            cardRating: '4.5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'الإسكندرية',
                            cardPrice: '300',
                            cardRating: '4.7',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'البحيرة',
                            cardPrice: '2300',
                            cardRating: '5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'كفر الدوار',
                            cardPrice: '123',
                            cardRating: '4',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'العصافرة',
                            cardPrice: '123',
                            cardRating: '5',
                          ),
                          CardComponent(
                            cardImage: 'assets/images/championship.png',
                            cardText: 'الحجر',
                            cardPrice: '200',
                            cardRating: '4',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
