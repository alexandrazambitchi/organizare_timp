import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';

import '../../model/group_activity.dart';
import '../../services/group_activity_service.dart';

class GroupActivityViewingPage extends StatelessWidget {
  final String groupId;

  final GroupActivity groupActivity;

  final String objId;

  const GroupActivityViewingPage(
      {Key? key, required this.groupActivity, required this.objId, required this.groupId,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Text(
              groupActivity.subject,
              style: const TextStyle(fontSize: 24),
            ),
            buildDateTime(groupActivity),
            const SizedBox(
              height: 10,
            ),
            Text(
              groupActivity.notes ?? 'Fara descriere',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              groupActivity.priority ?? 'Fara prioritate',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              groupActivity.location ?? 'Fara locatie',
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
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
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => GroupActivityEditPage(
                                groupId:  groupId,
                                groupActivity: groupActivity,
                                objId: objId,
                              ))),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildDateTime(GroupActivity groupActivity) {
    return Column(
      children: [
        buildDate(
            groupActivity.isAllDay ? 'Toata ziua' : 'De la ', groupActivity.startTime),
        if (!groupActivity.isAllDay) buildDate('Pana la ', groupActivity.endTime)
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
