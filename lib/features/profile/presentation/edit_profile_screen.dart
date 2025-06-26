import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/common/custom_coloured_button.dart';
import 'package:orado_customer/utilities/strings.dart';
import 'package:orado_customer/utilities/styles.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String route = 'edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, phone, address;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileProvider>();
    name = user.name;
    email = user.email;
    phone = user.phone;
    address = user.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style:
              AppStyles.getBoldTextStyle(fontSize: 22, color: AppColors.yellow),
        ),
        backgroundColor: AppColors.baseColor,
        iconTheme: IconThemeData(color: AppColors.yellow, size: 24),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.yellow, size: 24),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (String? text) => AppStrings.validateName(text),
                style: AppStyles.getRegularTextStyle(
                    fontSize: 16, color: AppColors.titleTextColor),
                initialValue: name,
                onSaved: (v) => name = v ?? '',
                decoration: InputDecoration(
                  labelText: 'Name',
                  focusColor: AppColors.baseColor,
                  labelStyle: AppStyles.getRegularTextStyle(
                      fontSize: 16, color: AppColors.titleTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                validator: (String? text) => AppStrings.validateEmail(text),
                keyboardType: TextInputType.emailAddress,
                style: AppStyles.getRegularTextStyle(
                    fontSize: 16, color: AppColors.titleTextColor),
                initialValue: email,
                onSaved: (v) => email = v ?? '',
                decoration: InputDecoration(
                  labelText: 'Email',
                  focusColor: AppColors.baseColor,
                  labelStyle: AppStyles.getRegularTextStyle(
                      fontSize: 16, color: AppColors.titleTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                validator: (String? text) => AppStrings.validatePhone(text),
                style: AppStyles.getRegularTextStyle(
                    fontSize: 16, color: AppColors.titleTextColor),
                initialValue: phone,
                keyboardType: TextInputType.phone,
                onSaved: (v) => phone = v ?? '',
                decoration: InputDecoration(
                  labelText: 'Phone',
                  focusColor: AppColors.baseColor,
                  labelStyle: AppStyles.getRegularTextStyle(
                      fontSize: 16, color: AppColors.titleTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                validator: (String? text) => AppStrings.validateAddress(text),
                keyboardType: TextInputType.streetAddress,
                style: AppStyles.getRegularTextStyle(
                    fontSize: 16, color: AppColors.titleTextColor),
                initialValue: address,
                decoration: InputDecoration(
                  labelText: 'Address',
                  focusColor: AppColors.baseColor,
                  labelStyle: AppStyles.getRegularTextStyle(
                      fontSize: 16, color: AppColors.titleTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.baseColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onSaved: (v) => address = v ?? '',
              ),
              const SizedBox(height: 32),
              CustomColouredButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      await context.read<ProfileProvider>().updateProfileOnApi(
                            name: name,
                            email: email,
                            phone: phone,
                            address: address,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile updated successfully!')),
                      );
                    }
                  },
                  label: 'Update Profile',
                  backGroundColor: AppColors.baseColor,
                  foreGroundColor: AppColors.yellow,
                  buttonHeight: 50),
            ],
          ),
        ),
      ),
    );
  }
}
