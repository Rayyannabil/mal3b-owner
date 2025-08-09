import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/components/location_picker.dart';
import 'package:mal3b/components/single_time_picker.dart';
import 'package:mal3b/components/time_picker.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mal3b/l10n/app_localizations.dart';
import 'package:mal3b/logic/cubit/add_stadium_cubit.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:mal3b/services/toast_service.dart';

class AddStadium extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddStadium({super.key, this.onSuccess});

  @override
  State<AddStadium> createState() => _AddStadiumState();
}

class _AddStadiumState extends State<AddStadium> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController ampriceController = TextEditingController();
  final TextEditingController pmpriceController = TextEditingController();

  String? nightTime;
  List<String> base64Images = [];
  List<MultipartFile> selectedMultipartImages = [];
  String? startTime24;
  String? endTime24;
  double? latitude;
  double? longitude;
  String? locationText;
  
  Future<File> compressImage(File file) async {
    final targetPath =
        '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50, 
    );

    return result != null ? File(result.path) : file; // if compression fails, return original file
  }
  
  Future<void> pickImagesAsMultipart() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    if (images.length > 6) {
      ToastService().showToast(
        message: 'يمكنك اختيار 6 صور فقط',
        type: ToastType.error,
      );
      return;
    }

    List<String> base64List = [];
    List<MultipartFile> multipartFiles = [];

    for (XFile image in images) {
      final file = File(image.path);
      final bytes = await file.readAsBytes();

      final base64 = base64Encode(bytes);
      base64List.add(base64);

      final multipartFile = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );
      multipartFiles.add(multipartFile);
    }

    selectedMultipartImages = multipartFiles;

    setState(() {
      base64Images = base64List;
    });
  }

  void submitStadium() async {
    if (_formKey.currentState!.validate()) {
      if (startTime24 == null || endTime24 == null) {
        ToastService().showToast(
          message: 'الرجاء اختيار وقت العمل',
          type: ToastType.error,
        );
        return;
      }

      if (latitude == null || longitude == null) {
        ToastService().showToast(
          message: 'الرجاء تحديد موقع الملعب',
          type: ToastType.error,
        );
        return;
      }

      if (base64Images.isEmpty) {
        ToastService().showToast(
          message: 'الرجاء إضافة صور للملعب',
          type: ToastType.error,
        );
        return;
      }

      await context.read<AddStadiumCubit>().addStadium(
        name: nameController.text.trim(),
        des: desController.text.trim(),
        amprice: double.parse(ampriceController.text),
        pmprice: double.parse(pmpriceController.text), // Fixed: was using ampriceController instead of pmpriceController
        selectedMultipartImages: selectedMultipartImages,
        nightTime: nightTime!,
        startTime24: startTime24!,
        endTime24: endTime24!,
        latitude: latitude!,
        longitude: longitude!,
        location: locationText!,
      );
      nameController.clear();
      desController.clear();
      ampriceController.clear();
      pmpriceController.clear();
      setState(() {
        selectedMultipartImages = [];
        base64Images = []; // Fixed: clear base64Images as well
        nightTime = null; // Fixed: reset nightTime properly
        startTime24 = null; // Fixed: set to null instead of empty string
        endTime24 = null; // Fixed: set to null instead of empty string
        latitude = null; // Fixed: reset latitude
        longitude = null; // Fixed: reset longitude
        locationText = null; // Fixed: set to null instead of empty string
      });

      print(selectedMultipartImages);
      print(locationText);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    desController.dispose();
    ampriceController.dispose();
    pmpriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStadiumCubit, AddStadiumState>(
      listener: (context, state) {
        if (state is AddStadiumSuccess) {
          ToastService().showToast(
            message: 'تمت إضافة الملعب بنجاح',
            type: ToastType.success,
          );
          widget.onSuccess?.call();
          // Fixed: removed setState from listener and moved stadium refresh logic
          context.read<StadiumCubit>().fetchStadiums();
        } else if (state is AddStadiumError) {
          String msg = state.msg.trim();
          if (!msg.endsWith('يا نجم')) {
            msg = '$msg يا نجم';
          }
          ToastService().showToast(message: msg, type: ToastType.error);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'ضيف ملعب',
                  style: TextStyle(
                    fontSize: getFontTitleSize(context) * 1.5,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.secondary,
                  ),
                ),
              ),
              SizedBox(height: getVerticalSpace(context, 30)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                        text: 'اسم الملعب',
                        controller: nameController,
                        isObsecure: false,
                        validator: ValidationBuilder(
                          requiredMessage: "دخل اسم الملعب",
                        ).required().build(),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 15)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                        text: 'وصف أو كلام عن الملعب',
                        controller: desController,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        isObsecure: false,
                        validator:
                            ValidationBuilder(requiredMessage: "دخل وصف الملعب")
                                .required()
                                .minLength(
                                  10,
                                  "الوصف لازم يكون 10 حروف على الأقل",
                                )
                                .maxLength(
                                  300,
                                  "الوصف طويل جداً (الحد الأقصى 300 حرف)",
                                )
                                .build(),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 15)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                        text: 'سعر/ساعة صباحا',
                        controller: ampriceController,
                        isObsecure: false,
                        keyboardType: TextInputType.number, // Fixed: added proper keyboard type
                        validator:
                            ValidationBuilder(
                              requiredMessage: "دخل سعر الملعب",
                            ).required().add((value) {
                              final number = num.tryParse(value ?? '');
                              if (number == null) return 'السعر لازم يكون رقم';
                              if (number <= 0) return 'السعر لازم يكون أكبر من صفر'; // Fixed: added positive number validation
                              return null;
                            }).build(),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 15)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                        text: 'سعر/ساعة مساء',
                        controller: pmpriceController,
                        isObsecure: false,
                        keyboardType: TextInputType.number, // Fixed: added proper keyboard type
                        validator:
                            ValidationBuilder(
                              requiredMessage: "دخل سعر الملعب",
                            ).required().add((value) {
                              final number = num.tryParse(value ?? '');
                              if (number == null) return 'السعر لازم يكون رقم';
                              if (number <= 0) return 'السعر لازم يكون أكبر من صفر'; // Fixed: added positive number validation
                              return null;
                            }).build(),
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 15)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: pickImagesAsMultipart,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ضيف صور الملعب",
                                style: TextStyle(
                                  fontSize: getFontSubTitleSize(context),
                                  color: CustomColors.secondary,
                                ),
                              ),
                              Icon(
                                base64Images.isEmpty
                                    ? Icons.add_a_photo_outlined
                                    : Icons.check_circle_outlined,
                                color: base64Images.isEmpty
                                    ? CustomColors.primary
                                    : Colors.green,
                                size: getIconWidth(context) * .9,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: getVerticalSpace(context, 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TimeRangePicker(
                        onTimeRangeSelectedFormatted: (start, end) {
                          setState(() {
                            startTime24 = start;
                            endTime24 = end;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 20)),
                    SingleTimePicker(
                      onTimeSelected: (formattedTime) {
                        setState(() { // Fixed: wrapped in setState to trigger UI update
                          nightTime = formattedTime;
                        });
                        print('Night time starts at: $formattedTime');
                      },
                    ),
                    SizedBox(height: getVerticalSpace(context, 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "مكان الملعب",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LocationPicker(
                            onLocationPicked: (lat, lng, address) {
                              setState(() {
                                latitude = lat;
                                longitude = lng;
                                locationText = address;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox( // Fixed: wrapped in SizedBox to give proper width
                        width: double.infinity,
                        child: state is AddStadiumLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: CustomColors.primary,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: submitStadium,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "إضافة",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}