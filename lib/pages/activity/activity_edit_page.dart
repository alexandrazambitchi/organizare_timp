import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/utils.dart';
import 'package:organizare_timp/model/activity.dart';

import '../../services/activity_service.dart';
import '../../services/notification_service.dart';

class ActivityEditPage extends StatefulWidget {
  final Activity? activity;
  final String? objId;

  const ActivityEditPage({Key? key, this.activity, this.objId})
      : super(key: key);

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  final formKey = GlobalKey<FormState>();
  late DateTime startDate;
  late DateTime endDate;

  final bool allDay = false;
  late bool isChecked = false;
  late bool isRecurrent = false;

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final categoryController = TextEditingController();
  final priorityController = TextEditingController();
  final recurrencyController = TextEditingController();
  final recurrencyFreqController = TextEditingController();
  final detailsController = TextEditingController();

  List<String> categories = ["Serviciu", "Casa", "Personal", "Timp liber"];
  List<String> priorities = ["Mare", "Mediu", "Mica"];
  List<String> recurrencyOptions = ["Zilnic", "Saptamanal", "Lunar"];
  String selectCategory = "";
  String selectPriority = "";
  String selectRecurrence = "";

  String? get objId => null;

  @override
  void initState() {
    super.initState();

    if (widget.activity == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 1));
    } else {
      final activity = widget.activity!;

      titleController.text = activity.subject;
      startDate = activity.startTime;
      endDate = activity.endTime;
      categoryController.text = activity.category!;
      selectCategory = activity.category!;
      priorityController.text = activity.priority!;
      selectPriority = activity.priority!;
      locationController.text = activity.location!;
      isRecurrent = activity.recurrenceRule != null;
      List<String> recurencySplit = activity.recurrenceRule!.split("=");
      recurrencyFreqController.text = recurencySplit.last;
      switch (recurencySplit[1].split(';')[0]) {
        case 'DAILY':
          selectRecurrence = 'Zilnic';
          break;
        case 'WEEKLY':
          selectRecurrence = 'Saptamanal';
          break;
        case 'MONTHLY':
          selectRecurrence = 'Lunar';
          break;
        default:
          selectRecurrence = 'Zilnic';
          break;
      }
      recurrencyController.text = selectRecurrence;
      detailsController.text = activity.notes!;
      isChecked = activity.isAllDay;
    }
  }

  Color setActivityColor(String category, String priority) {
    Color activityColor = Colors.blue;
    switch (category) {
      case 'Serviciu':
        switch (priority) {
          case 'Mare':
            activityColor = Colors.amber.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.amber.shade300;
            break;
          case 'Mica':
            activityColor = Colors.amber.shade100;
            break;
        }
        break;
      case 'Casa':
        switch (priority) {
          case 'Mare':
            activityColor = Colors.teal.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.teal.shade300;
            break;
          case 'Mica':
            activityColor = Colors.teal.shade100;
            break;
        }
        break;
      case 'Personal':
        switch (priority) {
          case 'Mare':
            activityColor = Colors.indigo.shade500;
            break;
          case 'Mediu':
            activityColor = Colors.indigo.shade300;
            break;
          case 'Mica':
            activityColor = Colors.indigo.shade100;
            break;
        }
        break;
      case 'Timp liber':
        switch (priority) {
          case 'Mare':
            activityColor = Colors.purple.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.purple.shade300;
            break;
          case 'Mica':
            activityColor = Colors.purple.shade100;
            break;
        }
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
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (isValid) {
      final activity = Activity(
          user: firebaseAuth.currentUser!.uid,
          subject: titleController.text,
          notes: detailsController.text,
          startTime: startDate,
          endTime: endDate,
          category: selectCategory,
          priority: selectPriority,
          recurrenceRule:
              setRecurrency(selectRecurrence, recurrencyFreqController.text),
          location: locationController.text,
          activityColor: setActivityColor(selectCategory, selectPriority),
          isAllDay: false);

      final isEditing = widget.activity != null;

      final ActivityService activityService = ActivityService();

      if (isEditing) {
        final objId = widget.objId!;
        activityService.editActivity(objId, activity);
      } else {
        activityService.addActivity(activity);
      }

      NotificationService().scheduleNotification(
          title: titleController.text,
          body: '$endDate',
          scheduleNotificationDateTime: endDate,
          payload: activity.id.toString());
      debugPrint('Notification Scheduled for $endDate');
      debugPrint('payload ${activity.id}');

      NotificationService().scheduleNotification(
          title: titleController.text,
          body: '$startDate',
          scheduleNotificationDateTime: startDate,
          payload: activity.id.toString());
      debugPrint('Notification Scheduled for $startDate');
      debugPrint('payload ${activity.id}');
      final snackBar = SnackBar(
        content: Text(
          'Notificare activata la $startDate',
          style: const TextStyle(fontSize: 24),
        ),
      );

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 178, 255),
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
                    title: const Text(
                      "Toata ziua",
                    ),
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
                DropDownField(
                  itemsVisibleInDropdown: categories.length,
                  controller: categoryController,
                  hintText: "Categorie",
                  enabled: true,
                  items: categories,
                  onValueChanged: (value) {
                    setState(() {
                      selectCategory = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                DropDownField(
                  itemsVisibleInDropdown: priorities.length,
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
                // const Text('Reminders setting'),
                const SizedBox(
                  height: 25,
                ),
                CheckboxListTile(
                    title: const Text("Activitate recurenta"),
                    controlAffinity: ListTileControlAffinity.platform,
                    value: isRecurrent,
                    onChanged: (value) {
                      setState(() {
                        isRecurrent = value!;
                      });
                    }),
                const SizedBox(
                  height: 25,
                ),
                setRecurrenceRule(),
                const SizedBox(
                  height: 25,
                ),
                setDetails(),
              ],
            ),
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

  Widget setRecurrenceRule() {
    if (isRecurrent) {
      return Column(
        children: [
          DropDownField(
            itemsVisibleInDropdown: recurrencyOptions.length,
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
            validator: (number) => number != null && number.isEmpty
                ? 'Frecventa trebuie sa fie minim 1'
                : null,
          )
        ],
      );
    }
    return Container();
  }
}
