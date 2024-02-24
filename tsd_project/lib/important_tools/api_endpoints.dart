import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;

//Read the config text and return it
class ReadJsonFile{

  static Future<String> readJsonData({required String path}) async {

    // read json file
    final jsondata = await root_bundle.rootBundle.loadString(path);

    // decode json data as list
    final list = json.decode(jsondata) as Map;

    return list["api_endpoint"];
  }
}

//Read api endpoints
class ReadApiEndpoints{

  static Future<Map> readApiEndpointsData() async{

    String apiUrl = await ReadJsonFile.readJsonData(path: "assets/cfg/api_endpoint.json");

    String baseApiUrl = '$apiUrl/api/ma';

    Map<String, String> apiEndpointsMap = {
      "registerEndpoint" : '$baseApiUrl/register/',

      "loginEndpoint" : '$baseApiUrl/login/',

      "requestQuizEndpoint" : '$baseApiUrl/quiz_send/',

      "quizResultStoreEndpoint" : '$baseApiUrl/quiz_data_store/',

      "viewQuizResultEndpoint" : '$baseApiUrl/view_quiz_result/',

      "viewPreviousQuizResultsEndpoint" : '$baseApiUrl/view_previous_quiz_results/',

      "requestPatientAuthUserDetailsEndpoint" : '$baseApiUrl/send_patient_auth_user_details/',

      "updatePatientAuthUserDetailsEndpoint" : '$baseApiUrl/update_patient_auth_user_details/',

      "requestPatientPersonalDetailsEndpoint" : '$baseApiUrl/send_patient_personal_details/',

      "updatePatientPersonalDetailsEndpoint" : '$baseApiUrl/update_patient_personal_details/',

      "requestCounselorDetailsEndpoint" : '$baseApiUrl/send_counselor_details/',

      "makeAppointmentEndpoint" : '$baseApiUrl/make_appointment/',

      "checkOngoingAppointmentEndpoint" : '$baseApiUrl/check_ongoing_appointment/',

      "requestAppointmentListEndpoint" : '$baseApiUrl/send_appointment_list/',

      "makeIsPatientViewedTrueEndpoint" : '$baseApiUrl/make_is_patient_viewed_true/',

      "requestNotificationAmountEndpoint" : '$baseApiUrl/send_notification_amount/',

      "requestPrivateQuestionsEndpoint" : '$baseApiUrl/send_private_questions/',

      "storePrivateQuestionEndpoint" : '$baseApiUrl/store_private_question/',

      "blacklistTokensEndpoint" : '$baseApiUrl/blacklist_tokens/',

      "requestDeleteAccountEndpoint" : '$baseApiUrl/delete_account/',

      "regenerateAccessTokenEndpoint" : '$baseApiUrl/regenerate_access_token/',
    };

    return apiEndpointsMap;
  }
}



