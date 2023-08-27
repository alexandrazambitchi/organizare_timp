import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/pages/activity/activity_edit_page.dart';
import 'package:organizare_timp/services/activity_service.dart';

class ActivityViewNotifPage extends StatefulWidget {
  final String? payload;

  const ActivityViewNotifPage({Key? key, this.payload}) : super(key: key);

  @override
  State<ActivityViewNotifPage> createState() => _ActivityViewNotifPageState();
}

class _ActivityViewNotifPageState extends State<ActivityViewNotifPage> {
  late Activity? activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromARGB(75, 102, 178, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 178, 255),
          leading: const CloseButton(),
        ),
        body: showActivity(widget.payload!));
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

  void findActivity(String id) async {
    ActivityService activityService = ActivityService();

    activity = await activityService.getActivityfromDB(id);
    debugPrint('${activity!.id}');
  }

  Widget showActivity(String id) {
    findActivity(id);

    return ListView(
      padding: const EdgeInsets.all(32),
      children: <Widget>[
        Text(
          activity!.subject,
          style: const TextStyle(fontSize: 24),
        ),
        buildDateTime(activity!),
        const SizedBox(
          height: 10,
        ),
        Text(
          activity!.notes ?? 'Fara descriere',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          activity!.category ?? 'Fara categorie',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          activity!.priority ?? 'Fara prioritate',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          activity!.location ?? 'Fara locatie',
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final activityService = ActivityService();
                activityService.deleteActivity(id);
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
                            objId: id,
                          ))),
            ),
          ],
        ),
      ],
    );
  }
}
