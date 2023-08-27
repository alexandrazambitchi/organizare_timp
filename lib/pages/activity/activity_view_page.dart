import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/pages/activity/activity_edit_page.dart';
import 'package:organizare_timp/services/activity_service.dart';

class ActivityViewingPage extends StatelessWidget {
  final Activity activity;

  final String objId;

  const ActivityViewingPage(
      {Key? key, required this.activity, required this.objId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 178, 255),
          leading: const CloseButton(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Text(
              activity.subject,
              style: const TextStyle(fontSize: 24),
            ),
            buildDateTime(activity),
            const SizedBox(
              height: 10,
            ),
            Text(
              activity.notes ?? 'Fara descriere',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              activity.category ?? 'Fara categorie',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              activity.priority ?? 'Fara prioritate',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              activity.location ?? 'Fara locatie',
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    final activityService = ActivityService();
                    activityService.deleteActivity(objId);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ActivityEditPage(
                                activity: activity,
                                objId: objId,
                              ))),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildDateTime(Activity activity) {
    return Column(
      children: [
        buildDate(
            activity.isAllDay ? 'Toata ziua' : 'De la ', activity.startTime),
        if (!activity.isAllDay) buildDate('Pana la ', activity.endTime)
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    final dateFormated = DateFormat('EEE, d/M/y').format(date);
    final time = DateFormat.Hm().format(date);

    return Row(
      children: [Text(title), Text('$dateFormated $time')],
    );
  }
}
