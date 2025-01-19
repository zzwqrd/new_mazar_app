import 'package:flutter/material.dart';
import 'package:mazar/common/models/api_response_model.dart';
import 'package:mazar/common/models/error_response_model.dart';
import 'package:mazar/features/auth/screens/login_screen.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/custom_snackbar_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/main.dart';
import 'package:provider/provider.dart';

class ApiCheckerHelper {
  static void checkApi(ApiResponseModel apiResponse) {
    ErrorResponseModel error = getError(apiResponse);

    if ((error.errors?[0].code == '401' ||
        error.errors![0].code == 'auth-001' &&
            ModalRoute.of(Get.context!)?.settings.name !=
                RouteHelper.getLoginRoute())) {
      Provider.of<SplashProvider>(Get.context!, listen: false)
          .removeSharedData();
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      showCustomSnackBarHelper(
          getTranslated(error.errors?.first.message, Get.context!));
    }
  }

  static ErrorResponseModel getError(ApiResponseModel apiResponse) {
    ErrorResponseModel error;

    try {
      error = ErrorResponseModel.fromJson(apiResponse);
    } catch (e) {
      if (apiResponse.error != null) {
        error = ErrorResponseModel.fromJson(apiResponse.error);
      } else {
        error = ErrorResponseModel(
            errors: [Errors(code: '', message: apiResponse.error.toString())]);
      }
    }
    return error;
  }
}
