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

  final String? cardImage;
  final String cardText;
  final String cardPrice;
  final double? cardRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                width: getHorizontalSpace(context, 270),
                height: getVerticalSpace(context, 310),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: cardImage != null
                        //make it image network after test
                            ? Image.asset(
                                cardImage!,
                                width: getHorizontalSpace(context, 230),
                                height: getVerticalSpace(context, 150),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 5),
                            child: Text(
                              cardText,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$cardPrice جنية / الساعة',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.primary,
                            ),
                          ),
                          SizedBox(height: getVerticalSpace(context, 5)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (cardRating != null
                                    ? cardRating!.toStringAsFixed(1)
                                    : "0.0")
                                .toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.primary,
                            ),
                          ),
                          SizedBox(width: getHorizontalSpace(context, 10)),
                          Image.asset(
                            'assets/images/star.png',
                            width: 20,
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
