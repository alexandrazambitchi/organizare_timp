import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityProvider extends ChangeNotifier{
  final List<Activity> activityList = [];

  List<Activity> get activities => activityList;

  void addActivity(Activity activity) {
    activityList.add(activity);

    notifyListeners();
  }
}