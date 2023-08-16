import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityProvider extends ChangeNotifier{
  final List<Activity> activityList = [];

  List<Activity> get activities => activityList;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Activity> get activitiesOfSelectedDate => activityList;

  void addActivity(Activity activity) {
    activityList.add(activity);

    notifyListeners();
  }

  void deleteActivity(Activity activity) {
    activityList.remove(activity);

    notifyListeners();
  }

  void editActivity(Activity newActivity, Activity oldActivity){
    final index = activityList.indexOf(oldActivity);

    activityList[index] = newActivity;

    notifyListeners();
  }
}