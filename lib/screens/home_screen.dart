// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart' hide Svg;
// import 'package:mal3b/services/location_service.dart';
// import 'package:mal3b/components/card_component.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController searchController = TextEditingController();
//   String _locationText = 'الموقع'; // Default text for location

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition(); // Call location service when the screen initializes
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   // Method to determine the current position
//   Future<void> _determinePosition() async {
//     try {
//       String address = await LocationService().determinePosition();
//       setState(() {
//         _locationText = address;
//       });
//     } catch (e) {
//       setState(() {
//         _locationText = 'خطأ: ${e.toString()}';
//       });
//       // Toast messages are now handled within LocationService
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // profile and notifications
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                       width: getHorizontalSpace(context, 234),
//                       height: getVerticalSpace(context, 134),
//                       decoration: const BoxDecoration(
//                         color: CustomColors.primary,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(50),
//                         ),
//                       ),
//                       child: SafeArea(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   'assets/images/profile.jpg',
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 40),
//                             SvgPicture.asset(
//                               "assets/images/notification.svg",
//                               width: getHorizontalSpace(context, 35),
//                               height: getVerticalSpace(context, 35),
//                             ),
//                             SizedBox(width: 30),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // location
//                   Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsetsDirectional.only(
//                         top: 75,
//                         start: 17,
//                         end: 17,
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: CustomColors.customWhite,
//                         ),
//                         height: getVerticalSpace(context, 39),
//                         width: getHorizontalSpace(context, 178),
//                         child: Text(
//                           _locationText, // Display fetched location or status
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: CustomColors.secondary.withOpacity(0.5),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: getVerticalSpace(context, 60)),

//             // offers and content
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: Text(
//                       'عروض',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: CustomColors.secondary,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 36)),

//                   // main card - cairo
//                   Center(
//                     child: Container(
//                       width: getHorizontalSpace(context, 440),
//                       height: getVerticalSpace(context, 234),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(40),
//                         image: DecorationImage(
//                           image: AssetImage('assets/images/championship.png'),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // rating
//                           Padding(
//                             padding: const EdgeInsetsDirectional.only(
//                               end: 20,
//                               start: 20,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: getVerticalSpace(context, 39)),
//                                 Text(
//                                   'القاهرة',
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     color: CustomColors.customWhite,
//                                   ),
//                                 ),
//                                 Text(
//                                   '300 جنيه / الساعة',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: CustomColors.customWhite,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.only(
//                                   start: 20,
//                                   end: 20,
//                                   top: 40,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       '4.5',
//                                       style: TextStyle(
//                                         color: CustomColors.customWhite,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: getHorizontalSpace(context, 5),
//                                     ),
//                                     Image.asset(
//                                       'assets/images/star.png',
//                                       width: 20,
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),

//                           // cairo
//                         ],
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: getVerticalSpace(context, 50)),

//                   // offers and content
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: Text(
//                       'الأفضل',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: CustomColors.secondary,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 10)),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'القاهرة',
//                           cardPrice: '200',
//                           cardRating: '4.5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'الإسكندرية',
//                           cardPrice: '300',
//                           cardRating: '4.7',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'البحيرة',
//                           cardPrice: '2300',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'كفر الدوار',
//                           cardPrice: '123',
//                           cardRating: '4',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'العصافرة',
//                           cardPrice: '123',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'الحجر',
//                           cardPrice: '200',
//                           cardRating: '4',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 50)),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: Text(
//                       'الأقرب',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: CustomColors.secondary,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 10)),

//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'القاهرة',
//                           cardPrice: '200',
//                           cardRating: '4.5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'الإسكندرية',
//                           cardPrice: '300',
//                           cardRating: '4.7',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'البحيرة',
//                           cardPrice: '2300',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'كفر الدوار',
//                           cardPrice: '123',
//                           cardRating: '4',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'العصافرة',
//                           cardPrice: '123',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: 'الحجر',
//                           cardPrice: '202130',
//                           cardRating: '4',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // profile and notifications
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: getHorizontalSpace(context, 234),
                      height: getVerticalSpace(context, 134),
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
                            SizedBox(
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile.jpg',
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            SvgPicture.asset(
                              "assets/images/notification.svg",
                              width: getHorizontalSpace(context, 35),
                              height: getVerticalSpace(context, 35),
                            ),
                            SizedBox(width: 30),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // location
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 75,
                        start: 17,
                        end: 17,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: CustomColors.customWhite,
                        ),
                        height: getVerticalSpace(context, 39),
                        width: getHorizontalSpace(context, 178),
                        child: Text(
                          _locationText, // Display fetched location or status
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.secondary.withOpacity(0.5),
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
                  SizedBox(height: getVerticalSpace(context, 36)),

                  // main card - cairo
                  Center(
                    child: Container(
                      width: getHorizontalSpace(context, 440),
                      height: getVerticalSpace(context, 234),
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
                                SizedBox(height: getVerticalSpace(context, 39)),
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
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart' hide Svg;
// import 'package:mal3b/services/location_service.dart';
// import 'package:mal3b/components/card_component.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';
// import 'package:mal3b/main.dart'; // Ensure language ValueNotifier is accessible
// import 'package:mal3b/l10n/app_localizations.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController searchController = TextEditingController();
//   String _locationText = 'الموقع'; // Default text, will be localized

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition(); // Call location service when the screen initializes
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   // Method to determine the current position
//   Future<void> _determinePosition() async {
//     try {
//       String address = await LocationService().determinePosition();
//       setState(() {
//         _locationText = address;
//       });
//     } catch (e) {
//       setState(() {
//         _locationText = 'خطأ: ${e.toString()}';
//       });
//       // Toast messages are now handled within LocationService
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // profile and notifications
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                       width: getHorizontalSpace(context, 234),
//                       height: getVerticalSpace(context, 134),
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(
//                             'assets/images/location_background.png',
//                           ),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       child: SafeArea(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   'assets/images/profile.jpg',
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 30),
//                             SvgPicture.asset(
//                               "assets/images/notification.svg",
//                               width: getHorizontalSpace(context, 30),
//                               height: getVerticalSpace(context, 30),
//                             ),
//                             SizedBox(width: 30),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // location
//                   Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsetsDirectional.only(
//                         top: 75,
//                         start: 17,
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: CustomColors.customWhite,
//                         ),
//                         height: getVerticalSpace(context, 39),
//                         width: getHorizontalSpace(context, 178),
//                         child: ValueListenableBuilder(
//                           valueListenable: language,
//                           builder: (context, value, child) => Text(
//                             _locationText,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: CustomColors.secondary.withOpacity(0.5),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: getVerticalSpace(context, 87)),

//             // offers and content
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: ValueListenableBuilder(
//                       valueListenable: language,
//                       builder: (context, value, child) => Text(
//                         language.value == "en"
//                             ? AppLocalizations.of(context)!.offers
//                             : 'عروض',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: CustomColors.secondary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 36)),

//                   // main card - cairo
//                   Center(
//                     child: Container(
//                       width: getHorizontalSpace(context, 440),
//                       height: getVerticalSpace(context, 234),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(40),
//                         image: DecorationImage(
//                           image: AssetImage('assets/images/championship.png'),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // rating
//                           Padding(
//                             padding: const EdgeInsetsDirectional.only(
//                               end: 20,
//                               start: 20,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: getVerticalSpace(context, 39)),
//                                 Text(
//                                   'القاهرة', // This could be localized if needed
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     color: CustomColors.customWhite,
//                                   ),
//                                 ),
//                                 Text(
//                                   '300 جنيه / الساعة', // This could be localized if needed
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: CustomColors.customWhite,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.only(
//                                   start: 20,
//                                   end: 20,
//                                   top: 40,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       '4.5',
//                                       style: TextStyle(
//                                         color: CustomColors.customWhite,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: getHorizontalSpace(context, 5),
//                                     ),
//                                     Image.asset(
//                                       'assets/images/star.png',
//                                       width: 20,
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: getVerticalSpace(context, 50)),

//                   // best content
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: ValueListenableBuilder(
//                       valueListenable: language,
//                       builder: (context, value, child) => Text(
//                         language.value == "en"
//                             ? AppLocalizations.of(context)!.best
//                             : 'الأفضل',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: CustomColors.secondary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 10)),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Cairo'
//                               : 'القاهرة',
//                           cardPrice: '200',
//                           cardRating: '4.5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Alexandria'
//                               : 'الإسكندرية',
//                           cardPrice: '300',
//                           cardRating: '4.7',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Beheira'
//                               : 'البحيرة',
//                           cardPrice: '2300',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Kafr El-Dawar'
//                               : 'كفر الدوار',
//                           cardPrice: '123',
//                           cardRating: '4',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Al-Asafirah'
//                               : 'العصافرة',
//                           cardPrice: '123',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Al-Hajr'
//                               : 'الحجر',
//                           cardPrice: '200',
//                           cardRating: '4',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 50)),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                       end: 29,
//                       start: 29,
//                     ),
//                     child: ValueListenableBuilder(
//                       valueListenable: language,
//                       builder: (context, value, child) => Text(
//                         language.value == "en"
//                             ? AppLocalizations.of(context)!.nearest
//                             : 'الأقرب',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: CustomColors.secondary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: getVerticalSpace(context, 10)),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Cairo'
//                               : 'القاهرة',
//                           cardPrice: '200',
//                           cardRating: '4.5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Alexandria'
//                               : 'الإسكندرية',
//                           cardPrice: '300',
//                           cardRating: '4.7',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Beheira'
//                               : 'البحيرة',
//                           cardPrice: '2300',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Kafr El-Dawar'
//                               : 'كفر الدوار',
//                           cardPrice: '123',
//                           cardRating: '4',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Al-Asafirah'
//                               : 'العصافرة',
//                           cardPrice: '123',
//                           cardRating: '5',
//                         ),
//                         CardComponent(
//                           cardImage: 'assets/images/championship.png',
//                           cardText: language.value == "en"
//                               ? 'Al-Hajr'
//                               : 'الحجر',
//                           cardPrice: '202130',
//                           cardRating: '4',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
