import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/helpers/size_helper.dart';

class AddStadium extends StatefulWidget {
  const AddStadium({super.key});

  @override
  State<AddStadium> createState() => _AddStadiumState();
}

class _AddStadiumState extends State<AddStadium> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<String> base64Images = [];
  List<MultipartFile> selectedMultipartImages = [];

  String? startTime24;
  String? endTime24;
  double? latitude;
  double? longitude;
  String? locationText;

  Future<void> pickImagesAsMultipart() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    List<String> base64List = [];
    List<MultipartFile> multipartFiles = [];

    for (XFile image in images) {
      final file = File(image.path);
      final bytes = await file.readAsBytes();

      // Base64 for preview or UI
      final base64 = base64Encode(bytes);
      base64List.add(base64);

      // Multipart file for backend
      final multipartFile = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );
      multipartFiles.add(multipartFile);
    }

    // Store multipartFiles in a variable for later submission
    selectedMultipartImages = multipartFiles;

    setState(() {
      base64Images = base64List;
    });
  }

  void submitStadium() {
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

      final stadiumData = {
        "name": nameController.text,
        "description": desController.text,
        "price": priceController.text,
        "images": selectedMultipartImages,
        "from": startTime24,
        "to": endTime24,

        "location": locationText,
        "latitude": latitude,
        "longitude": longitude,
      };

      print("🎯 Stadium Data:");
      print("Name: ${nameController.text}");
      print("Description: ${desController.text}");
      print("Price: ${priceController.text}");
      print(
        "Images: ${selectedMultipartImages.map((f) => f.filename).toList()}",
      );
      print("From: $startTime24");
      print("To: $endTime24");
      print("Location: ($latitude, $longitude)");

      // Example:
      context.read<AddStadiumCubit>().addStadium(
        name: nameController.text.trim(),
        des: desController.text.trim(),
        price: double.parse(priceController.text),
        selectedMultipartImages: selectedMultipartImages,
        startTime24: startTime24!,
        endTime24: endTime24!,
        latitude: latitude!,
        longitude: longitude!,
        // locationText: locationText ?? '',
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    desController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'ضيف ملعب',
            style: TextStyle(fontSize: getFontTitleSize(context) * 1.2),
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
                  validator: ValidationBuilder(
                    requiredMessage: "دخل اسم الملعب",
                  ).required().build(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
