import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/utils.dart';
import '../../model/group_activity.dart';
import '../../services/group_activity_service.dart';

class GroupActivityEditPage extends StatefulWidget {
  final GroupActivity? groupActivity;
  final String? objId;
  final String groupId;

  const GroupActivityEditPage(
      {Key? key, this.groupActivity, this.objId, required this.groupId})
      : super(key: key);

  @override
  State<GroupActivityEditPage> createState() => _GroupActivityEditPageState();
}

class _GroupActivityEditPageState extends State<GroupActivityEditPage> {
  final formKey = GlobalKey<FormState>();
  late DateTime startDate;
  late DateTime endDate;

  final bool allDay = false;
  late bool isChecked = false;

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final priorityController = TextEditingController();
  final recurrencyController = TextEditingController();
  final recurrencyFreqController = TextEditingController();
  final detailsController = TextEditingController();

  List<String> priorities = ["Important", "Mediu", "Scazut"];
  List<String> recurrencyOptions = ["Zilnic", "Saptamanal", "Lunar"];
  String selectPriority = "";
  String selectRecurrence = "";

  String? get objId => null;

  @override
  void initState() {
    super.initState();

    if (widget.groupActivity == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 1));
    } else {
      final activity = widget.groupActivity!;

      titleController.text = activity.subject;
      startDate = activity.startTime;
      endDate = activity.endTime;
      locationController.text = activity.location!;
      recurrencyController.text = activity.recurrenceRule!;
      priorityController.text = activity.priority!;
      detailsController.text = activity.notes!;
      isChecked = activity.isAllDay;
    }
  }

  Color setActivityColor(String priority) {
    Color activityColor = Colors.blue;
    switch (priority) {
      case 'Important':
        activityColor = Colors.blue.shade600;
        break;
      case 'Mediu':
        activityColor = Colors.blue.shade300;
        break;
      case 'Scazut':
        activityColor = Colors.blue.shade100;
        break;
    }
    return activityColor;
  }

  String setRecurrency(String selectedRecurrency, String number) {
    //FREQ=DAILY;INTERVAL=1;COUNT=10
    switch (selectedRecurrency) {
      case 'Zilnic':
        return 'FREQ=DAILY;COUNT=$number';
      case 'Saptamanal':
        return 'FREQ=WEEKLY;COUNT=$number';
      case 'Lunar':
        return 'FREQ=MONTHLY;COUNT=$number';
    }
    return 'FREQ=DAILY;COUNT=1';
  }

  void saveNewActivity() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final groupActivity = GroupActivity(
        subject: titleController.text,
        startTime: startDate,
        endTime: endDate,
        notes: detailsController.text,
        location: locationController.text,
        recurrenceRule: setRecurrency(
            recurrencyController.text, recurrencyFreqController.text),
        isAllDay: isChecked,
        priority: selectPriority,
      );

      final isEditing = widget.groupActivity != null;

      final GroupActivityService groupActivityService = GroupActivityService();

      if (isEditing) {
        final objId = widget.objId!;
        groupActivity.groupId = widget.groupId;
        groupActivityService.editActivity(widget.groupId, objId, groupActivity);
      } else {
        groupActivityService.addActivity(widget.groupId, groupActivity);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded),
              onPressed: saveNewActivity,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                setTitle(),

                const SizedBox(
                  height: 25,
                ),

                CheckboxListTile(
                    title: const Text("Toata ziua"),
                    controlAffinity: ListTileControlAffinity.platform,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                const SizedBox(
                  height: 25,
                ),
                dateTimePickers(),
                const SizedBox(
                  height: 25,
                ),
                setLocation(),
                const SizedBox(
                  height: 25,
                ),

                const SizedBox(
                  height: 25,
                ),
                // setPriority(),
                DropDownField(
                  controller: priorityController,
                  hintText: "Prioritate",
                  enabled: true,
                  items: priorities,
                  onValueChanged: (value) {
                    setState(() {
                      selectPriority = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text('Reminders setting'),
                const SizedBox(
                  height: 25,
                ),
                setDetails(),
                const SizedBox(
                  height: 25,
                ),
                // Row(
                //   children: [
                DropDownField(
                  controller: recurrencyController,
                  hintText: "Recurenta",
                  enabled: true,
                  items: recurrencyOptions,
                  onValueChanged: (value) {
                    setState(() {
                      selectRecurrence = value;
                    });
                  },
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Frecventa recurentei'),
                  controller: recurrencyFreqController,
                )
              ],
            ),
            // ],
            // ),
          ),
        ));
  }

  Widget setTitle() => TextFormField(
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Titlu'),
        onFieldSubmitted: (_) => saveNewActivity(),
        validator: (title) => title != null && title.isEmpty
            ? 'Activitatea trebuie sa aiba un titlu'
            : null,
        controller: titleController,
      );

  Widget dateTimePickers() => Column(
        children: [
          buildStarting(),
          buildEnding(),
        ],
      );

  Widget buildStarting() => buildHeader(
        header: 'De la',
        child: Row(
          children: [
            Expanded(
                child: buildDropdownField(
              text: Utils.toDate(startDate),
              onClicked: () => pickStartingDateTime(pickDate: true),
            )),
            Expanded(
                child: buildDropdownField(
              text: Utils.toTime(startDate),
              onClicked: () => pickStartingDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Widget buildEnding() => buildHeader(
        header: 'Pana la',
        child: Row(
          children: [
            Expanded(
                child: buildDropdownField(
              text: Utils.toDate(endDate),
              onClicked: () => pickEndingDateTime(pickDate: true),
            )),
            Expanded(
                child: buildDropdownField(
              text: Utils.toTime(endDate),
              onClicked: () => pickEndingDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Future pickStartingDateTime({required bool pickDate}) async {
    final date =
        await pickDateTime(startDate, pickDate: pickDate, isAEndTime: false);

    if (date == null) return;

    if (date.isAfter(endDate)) {
      endDate = DateTime(
          date.year, date.month, date.day, endDate.hour, endDate.minute);
    }

    setState(() => startDate = date);
  }

  Future pickEndingDateTime({required bool pickDate}) async {
    final date = await pickDateTime(endDate,
        pickDate: pickDate,
        firstDate: pickDate ? startDate : null,
        isAEndTime: true);

    if (date == null) return;

    setState(() => endDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate,
      DateTime? firstDate,
      required isAEndTime}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015, 8),
          lastDate: DateTime(2101));

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      if (!isChecked) {
        final timeSelected = await showTimePicker(
            context: context,
            initialEntryMode: TimePickerEntryMode.input,
            initialTime: TimeOfDay.fromDateTime(initialDate));

        if (timeSelected == null) return null;

        final date =
            DateTime(initialDate.year, initialDate.month, initialDate.day);
        final time =
            Duration(hours: timeSelected.hour, minutes: timeSelected.minute);

        return date.add(time);
      } else {
        final date =
            DateTime(initialDate.year, initialDate.month, initialDate.day);
        const timeStart = Duration(hours: 0, minutes: 0);
        const timeEnd = Duration(hours: 23, minutes: 59);
        if (isAEndTime) {
          return date.add(timeEnd);
        } else {
          return date.add(timeStart);
        }
      }
    }
  }

  Widget buildDropdownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
          child
        ],
      );

  Widget setLocation() => TextFormField(
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Locatie'),
        controller: locationController,
      );

  Widget setDetails() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Descriere'),
        controller: detailsController,
      );
}
