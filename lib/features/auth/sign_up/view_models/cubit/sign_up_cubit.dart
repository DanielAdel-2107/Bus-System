import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bus_system/core/network/supabase/auth/sign_up_with_password.dart';
import 'package:bus_system/core/network/supabase/database/add_data.dart';
import 'package:bus_system/core/network/supabase/storage/upload_file.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  // var
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  File? imageFile;
  bool acceptTerms = false;
  // fun
  toggleTermsAndPolicy() {
    acceptTerms = !acceptTerms;
    emit(ChangeTermsAndPolicy());
  }

  // pick image
  pickUserImage({required ImageSource source}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        emit(PickUserImageSuccess());
      }
    } catch (e) {
      emit(PickUserImageFailure(errorMessage: e.toString()));
    }
  }

  // sign up
  signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        if (acceptTerms == false) {
          emit(AcceptTermsAndPolicy());
          return;
        }
        if (passwordController.text != confirmPasswordController.text) {
          emit(PasswordDontMatch());
          return;
        }
        if (imageFile == null) {
          emit(ImageRequired());
          return;
        }
        emit(SignUpLoading());
        await signUpWithPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await addData(
          tableName: "users",
          data: {
            "full_name": nameController.text,
            "email": emailController.text,
            "phone_number": phoneController.text,
            "image": await uploadFileToSupabaseStorage(
              file: imageFile!,
              pucketName: "users-images",
            )
          },
        );
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(errorMessage: e.toString()));
      }
    }
  }
}
