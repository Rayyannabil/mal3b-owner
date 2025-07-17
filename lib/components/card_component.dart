import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class CardComponent extends StatelessWidget {
  const CardComponent({
    super.key,
    required this.cardImage,
    required this.cardText,
    required this.cardPrice,
    required this.cardRating,
  });
  final String cardImage;
  final String cardText;
  final String cardPrice;
  final String cardRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // first card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // card body
              Container(
                width: getHorizontalSpace(context, 270),
                height: getVerticalSpace(context, 310),
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E9), // Light green color from the image
                  borderRadius: BorderRadius.circular(
                    40,
                  ), // Adjusted border radius
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align content to the start
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                        10.0,
                      ), // Padding around the image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          40,
                        ), // Rounded corners for the image
                        child: Image.asset(
                          cardImage,
                          width: getHorizontalSpace(
                            context,
                            230,
                          ), // Adjusted width for image
                          height: getVerticalSpace(
                            context,
                            150,
                          ), // Adjusted height for image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ), // Padding for text content
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cardText,
                            style: TextStyle(
                              fontSize: 18, // Adjusted font size
                              fontWeight: FontWeight.bold,
                              color: CustomColors
                                  .secondary, // Assuming secondary is the dark green
                            ),
                          ),
                          Text(
                            '$cardPrice جنية / الساعة',
                            style: TextStyle(
                              fontSize: 14, // Adjusted font size
                              color: CustomColors.primary,
                            ),
                          ),
                          SizedBox(
                            height: getVerticalSpace(context, 5),
                          ), // Space before rating
                        ],
                      ),
                    ),
                    // Rating at the bottom center
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cardRating,
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.primary,
                            ),
                          ),
                          SizedBox(width: getHorizontalSpace(context, 10)),
                          Image.asset(
                            'assets/images/star.png',
                            width: 20, // Adjusted star size
                            height: 20,
                            color: CustomColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
