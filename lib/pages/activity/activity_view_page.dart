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
          title: const Text('Detalii activitate'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: <Widget>[
                  Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        activity.subject,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDateTime(activity),
                      const SizedBox(
                        height: 15,
                      ),
                      showDetails(),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 35.0,
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
                    iconSize: 35.0,
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
            ),
          ],
        ));
  }

  Widget buildDateTime(Activity activity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDate(
            activity.isAllDay ? 'Toata ziua' : 'De la: ', activity.startTime),
        if (!activity.isAllDay) buildDate('Pana la: ', activity.endTime)
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    final dateFormated = DateFormat('d/M/y').format(date);
    final time = DateFormat.Hm().format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          '$dateFormated $time',
          style: const TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget showDetails() {
    late String category = 'Fara categorie';
    late String notes = 'Fara descriere';
    late String location = 'Fara locatie';
    late String priority = 'Fara prioritate';
    late String recurency = 'Fara recurenta';
    if (activity.category != "") {
      category = activity.category!;
    }
    if (activity.notes != "") {
      notes = activity.notes!;
    }
    if (activity.location != "") {
      location = activity.location!;
    }
    if (activity.priority != "") {
      priority = activity.priority!;
    }
    if (activity.recurrenceRule != "") {
      List<String> recurencySplit = activity.recurrenceRule!.split("=");
      final freq = recurencySplit.last;
      switch (recurencySplit[1].split(';')[0]) {
        case 'DAILY':
          recurency = 'Zilnic, frecventa: $freq';
          break;
        case 'WEEKLY':
          recurency = 'Saptamanal, frecventa: $freq';
          break;
        case 'MONTHLY':
          recurency = 'Lunar, frecventa: $freq';
          break;
        default:
          recurency = activity.recurrenceRule!;
          break;
      }
    }

    return Column(
      children: [
        const Text(
          'Locatie:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          location,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
          'Categorie:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          category,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
          'Prioritate:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          priority,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
          'Recurenta:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          recurency,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
          'Detalii:',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          notes,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
