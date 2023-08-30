import 'package:flutter/material.dart';

import '../model/user_model.dart';

class MultiSelect extends StatefulWidget {
  final List<UserModel>? users;
  final List<UserModel>? alreadySelected;
  const MultiSelect({Key? key, this.users, this.alreadySelected})
      : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<UserModel> selectedUsers = [];

  void itemChange(UserModel itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedUsers.add(itemValue);
      } else {
        selectedUsers.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void submit() {
    Navigator.pop(context, selectedUsers);
  }

  // void checkIfAlreadyChecked() {
  //   if (widget.users != null) {
  //     for (var user in widget.users!) {
  //       if (widget.alreadySelected!.contains(user)) {
  //         itemChange(user, true);
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // checkIfAlreadyChecked();
    return AlertDialog(
      title: const Text('Alege utilizatorii'),
      content: SingleChildScrollView(
          child: ListBody(
        children: widget.users!
            .map((user) => CheckboxListTile(
                value: selectedUsers.contains(user),
                title: Text(user.name),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) => itemChange(user, isChecked!)))
            .toList(),
      )),
      actions: [
        TextButton(onPressed: cancel, child: const Text('Anuleaza')),
        TextButton(onPressed: submit, child: const Text('Salveaza'))
      ],
    );
  }
}
