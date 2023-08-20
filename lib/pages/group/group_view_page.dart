import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/group_activity/group_activities_day_view_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../model/group.dart';
import 'group_edit_page.dart';

class GroupViewingPage extends StatelessWidget {
  final Group group;

  final String objId;

  const GroupViewingPage({Key? key, required this.group, required this.objId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Text(
              group.name,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              group.description!,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              group.leader,
              style: const TextStyle(fontSize: 16),
            ),
            Button(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            GroupActivityDayViewPage(groupId: objId))),
                text: "Vezi activitatile de azi"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => GroupActivityEditPage(
                                  groupId: objId,
                                ))),
                    icon: const Icon(Icons.add)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    final groupService = GroupService();

                    groupService.deleteGroup(objId);
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
                          builder: (context) => GroupEditPage(
                                group: group,
                                objId: objId,
                              ))),
                ),
              ],
            ),
          ],
        ));
  }
}
