import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/models/user.dart';
import 'package:unbroken/models/workout_type.dart';
import 'package:unbroken/services/storage_service.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';

class ProfileInfoUpdateModal extends StatelessWidget {
  final User user;

  const ProfileInfoUpdateModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff141414),
        width: double.infinity,
        child: Padding(
            // padding: const EdgeInsets.all(16.0),
            padding: EdgeInsets.fromLTRB(16, 16,16,
                MediaQuery.of(context).viewInsets.bottom),
            child: ProfileInfoUpdateModalForm(user: user)));
  }
}

class ProfileInfoUpdateModalForm extends StatefulWidget {
  final User user;

  const ProfileInfoUpdateModalForm({super.key, required this.user});

  @override
  State<ProfileInfoUpdateModalForm> createState() =>
      _ProfileInfoUpdateModalFormState();
}

class _ProfileInfoUpdateModalFormState
    extends State<ProfileInfoUpdateModalForm> {
  // digits 7-15 long
  final _phoneRegExp = RegExp(r'^\d{7,15}$');
  String _imageName = "Select image";
  XFile? _imageFile;
  final int _imageMaxFileSize = 10 * 1048576; // 10MB
  String? _lastErrorMessage;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  late WorkoutType _workoutType;

  final apiService = getIt<ApiService>();
  final storageService = getIt<StorageService>();

  @override
  void initState() {
    _workoutType = widget.user.workoutType;
    super.initState();
  }

  void _showMessage(final bool isSuccess) {
    if (!isSuccess) {
      setState(() {
        _lastErrorMessage = "There was an error, try again later.";
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User information updated successfully!"),
        backgroundColor: Colors.blue,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if ((await image.readAsBytes()).length >= _imageMaxFileSize) {
      setState(() {
        _lastErrorMessage = "Image size cannot exceed 10MB!";
      });
      return;
    }
    setState(() {
      _lastErrorMessage = null;
      _imageName = image.name;
      _imageFile = image;
    });
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      File? file = _imageFile != null ? File(_imageFile!.path) : null;
      await apiService.putWithFile(ApiEndpoints.updateUserInfo,
          body: User.updateInfo(
              fullName: _fullNameController.text,
              phoneNumber: _phoneNumberController.text,
              instagramUrl: _instagramController.text,
              workoutType: _workoutType),
          bodyFieldName: "user",
          file: file,
          fileFieldName: "image");
      await storageService.updateUserInfo(_workoutType);
      _showMessage(true);
    } on ApiError catch (e) {
      _showMessage(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("User information",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 20),
              DefaultFormField(
                controller: _fullNameController,
                labelText: 'Full name',
                icon: Icons.person,
                value: widget.user.fullName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name!';
                  }
                  return null;
                },
              ),
              GlobalConstants.defaultColumnsSpacing,
              DefaultFormField(
                controller: _phoneNumberController,
                labelText: 'Phone number',
                icon: Icons.phone,
                value: widget.user.phoneNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number!';
                  }
                  String cleanedValue = value.replaceAll(' ', '');
                  if (!_phoneRegExp.hasMatch(cleanedValue)) {
                    return 'Please enter a valid phone number (7-15 digits)!';
                  }
                  if (value.length > 15) {
                    return 'Phone number should not exceed 15 characters including spaces';
                  }
                  return null;
                },
              ),
              GlobalConstants.defaultColumnsSpacing,
              DefaultFormField(
                controller: _instagramController,
                labelText: 'Instagram handle',
                icon: Icons.share,
                value: widget.user.instagramUrl
              ),
              GlobalConstants.defaultColumnsSpacing,
              DropdownButtonFormField<WorkoutType>(
                value: widget.user.workoutType,
                onChanged: (WorkoutType? value) {
                  _workoutType = value!;
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: GoogleFonts.poppins(
                      color: const Color(0xFF585858),
                      fontWeight: FontWeight.w300,
                    ),
                    hintText: "Category",
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF585858),
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: GlobalConstants.inputBorderRadius,
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: GlobalConstants.inputBorderRadius,
                      borderSide: const BorderSide(
                          color: GlobalConstants.inputDefaultBorderColor,
                          width: 1.0), // Color for unfocused state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: GlobalConstants.inputBorderRadius,
                      borderSide: const BorderSide(
                          color: Color(0xFF2D2D2D),
                          width: 1.0), // Color for focused state
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: GlobalConstants.inputBorderRadius,
                      borderSide: const BorderSide(
                          color: Color(0xFFFF0000),
                          width: 1.0), // Color for focused state
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.category_rounded)),
                dropdownColor: const Color(0xff141414),
                items: WorkoutType.values.map<DropdownMenuItem<WorkoutType>>(
                    (WorkoutType workoutType) {
                  return DropdownMenuItem<WorkoutType>(
                    value: workoutType,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(workoutType.value),
                      ],
                    ),
                  );
                }).toList(),
              ),
              GlobalConstants.defaultColumnsSpacing,
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _uploadImage();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        backgroundColor: const Color(0xff141414),
                        side: const BorderSide(
                          width: 1,
                          color: GlobalConstants.inputDefaultBorderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: GlobalConstants.inputBorderRadius,
                        ),
                      ),
                      child: Text(_imageName,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF585858),
                            fontWeight: FontWeight.w300,
                          )))),
              if (_lastErrorMessage != null)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          _lastErrorMessage!,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Color(0xffDA0000), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _updateUserInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        backgroundColor: GlobalConstants.saveButtonBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Save",
                          style: GoogleFonts.poppins(
                            color: GlobalConstants.saveButtonTextColor,
                            fontWeight: FontWeight.w300,
                          )))),
            ],
          ))
    ]);
  }
}
