import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/models/password_change_request.dart';
import 'package:unbroken/util/error_messages.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';
import 'package:unbroken/util/widgets/password_form_field.dart';

class PasswordUpdateModal extends StatelessWidget {
  const PasswordUpdateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff141414),
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16,16,
                MediaQuery.of(context).viewInsets.bottom),
            child: const _PasswordUpdateModalForm()));
  }
}

class _PasswordUpdateModalForm extends StatefulWidget {
  const _PasswordUpdateModalForm({super.key});

  @override
  State<_PasswordUpdateModalForm> createState() =>
      _PasswordUpdateModalFormState();
}

class _PasswordUpdateModalFormState extends State<_PasswordUpdateModalForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();

  String? _serverError;

  final apiService = getIt<ApiService>();

  void _showMessage(final bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSuccess
            ? "Password changed successfully!"
            : "There was an error, try again later."),
        backgroundColor: isSuccess ? Colors.blue : Colors.red,
      ),
    );
    if (isSuccess) {
      Navigator.pop(context);
    }
  }

  Future<void> _changePassword() async {
    _serverError = null;
    if (!_formKey.currentState!.validate()) return;
    try {
      await apiService.put(ApiEndpoints.changePassword,
          body: PasswordChangeRequest(
                  _oldPasswordController.text, _newPasswordController.text)
              .toJson());
      _showMessage(true);
    } on ApiError catch (e) {
      if (e.code == "incorrect-old-password") {
        setState(() {
          _serverError = ErrorMessages.getMessage(e.code);
        });
        _formKey.currentState!.validate();
      } else {
        _showMessage(false);
      }
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
                  Text("Change password",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 20),
              DefaultPasswordFormField(
                controller: _oldPasswordController,
                labelText: 'Old password',
                icon: Icons.password_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password!';
                  }
                  return null;
                },
              ),
              GlobalConstants.defaultColumnsSpacing,
              DefaultPasswordFormField(
                controller: _newPasswordController,
                labelText: 'New password',
                icon: Icons.password_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password!';
                  }
                  if (value.length < 6) {
                    return 'New password must be at least 6 characters long!';
                  }
                  return null;
                },
              ),
              GlobalConstants.defaultColumnsSpacing,
              DefaultPasswordFormField(
                controller: _newPasswordConfirmationController,
                labelText: 'Confirm password',
                icon: Icons.password_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your new password!';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match!';
                  }
                  if (_serverError != null) {
                    return _serverError;
                  }
                  return null;
                },
              ),
              GlobalConstants.defaultColumnsSpacing,
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _changePassword();
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
