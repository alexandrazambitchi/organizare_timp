import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/group_activity.dart';
import '../../services/group_activity_service.dart';
import 'group_activity_edit_page.dart';

class GroupActivityViewingPage extends StatelessWidget {
  final String groupId;

  final GroupActivity groupActivity;

  final String objId;

  const GroupActivityViewingPage({
    Key? key,
    required this.groupActivity,
    required this.objId,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 178, 255),
          leading: const CloseButton(),
          title: const Text('Detalii activitate grup'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: <Widget>[
                  Text(
                    groupActivity.subject,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildDateTime(groupActivity),
                  const SizedBox(
                    height: 15,
                  ),
                  showDetails(),
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
                      final groupActivityService = GroupActivityService();
                      groupActivityService.deleteActivity(groupId, objId);
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
                            builder: (context) => GroupActivityEditPage(
                                  groupId: groupId,
                                  groupActivity: groupActivity,
                                  objId: objId,
                                ))),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildDateTime(GroupActivity groupActivity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDate(groupActivity.isAllDay ? 'Toata ziua' : 'De la: ',
            groupActivity.startTime),
        if (!groupActivity.isAllDay)
          buildDate('Pana la: ', groupActivity.endTime)
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
    late String notes = 'Fara detalii';
    late String location = 'Fara locatie';
    late String priority = 'Fara prioritate';
    late String recurency = 'Fara recurenta';
    if (groupActivity.notes != "") {
      notes = groupActivity.notes!;
    }
    if (groupActivity.location != "") {
      location = groupActivity.location!;
    }
    if (groupActivity.priority != "") {
      priority = groupActivity.priority!;
    }
    if (groupActivity.recurrenceRule != "") {
      List<String> recurencySplit = groupActivity.recurrenceRule!.split("=");
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
          recurency = groupActivity.recurrenceRule!;
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
