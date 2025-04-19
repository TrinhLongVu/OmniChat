import 'package:flutter/material.dart';
import 'package:omni_chat/apis/auth/controllers/get_me.dart';
import 'package:omni_chat/apis/auth/controllers/get_usage.dart';
import 'package:omni_chat/apis/auth/models/response.dart';

class UserProvider extends ChangeNotifier {
  String username;
  String email;
  String subscriptionPlan;

  UserProvider({
    this.username = "",
    this.email = "",
    this.subscriptionPlan = "",
  });

  void setUser() async {
    GetMeResponse? fetchedUser = await getMe();
    GetUsageResponse? usageResponse = await getUsage();
    if (fetchedUser != null) {
      username = fetchedUser.username;
      email = fetchedUser.email;
      notifyListeners();
    }
    if (usageResponse != null && usageResponse.name.isNotEmpty) {
      subscriptionPlan =
          usageResponse.name[0].toUpperCase() +
          usageResponse.name.substring(1).toLowerCase();
      notifyListeners();
    }
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }
}
