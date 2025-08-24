import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/drop_down_menu.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

final List<String> wallets = ['Vodafone Cash', 'Orange Cash', 'InstaPay'];
String selectedItem = wallets[0];

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,

        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 20,
                      end: 20,
                      top: 30,
                    ),
                    child: SafeArea(
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
                  ),
                ],
              ),
              SizedBox(height: getVerticalSpace(context, 50)),
              SvgPicture.asset(
                'assets/images/payment.svg',
                width: getImageHeight(context),
              ),
              SizedBox(height: getVerticalSpace(context, 40)),
              DropDownMenu(
                items: wallets,
                selectedItem: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value!;
                  });
                },
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 20,
                    end: 20,
                    top: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ثمن الحجز',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        '300',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getVerticalSpace(context, 35)),
              Divider(indent: 50, endIndent: 50, color: Colors.black),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 20,
                    end: 20,
                    top: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        '300',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
              CustomButton(
                onPressed: () {},
                bgColor: CustomColors.primary,
                fgColor: Colors.white,
                text: const Text('إستمرار'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
