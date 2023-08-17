import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/utils.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:provider/provider.dart';

import '../provider/activity_provider.dart';

class ActivityEditPage extends StatefulWidget {

  final Activity? activity;
  
  const ActivityEditPage({Key? key, this.activity,}) : super(key: key);

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  final formKey = GlobalKey<FormState>();
  late DateTime startDate;
  late DateTime endDate;

  final bool allDay = false;
  late bool isChecked = false;

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final categoryController = TextEditingController();
  final priorityController = TextEditingController();
  final recurrencyController = TextEditingController();
  final recurrencyFreqController = TextEditingController();
  final detailsController = TextEditingController();

  List<String> categories = ["Serviciu", "Casa", "Personal", "Timp liber"];
  List<String> priorities = ["Important", "Mediu", "Scazut"];
  List<String> recurrencyOptions = ["Zilnic", "Saptamanal", "Lunar"];
  String selectCategory = "";
  String selectPriority = "";
  String selectRecurrence = "";
  


  @override
  void initState() {
    super.initState();

    if (widget.activity == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 1));
    } else {
      final activity = widget.activity!;

      titleController.text = activity.title;
      startDate = activity.startTime;
      endDate = activity.endTime;
    }
  }

  Color setActivityColor(String category, String priority){
    Color activityColor = Colors.blue;
    switch(category){
      case 'Serviciu':
        switch(priority){
          case 'Important':
            activityColor = Colors.amber.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.amber.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.amber.shade100;
            break;
        }
        break;
      case 'Casa':
        switch(priority){
          case 'Important':
            activityColor = Colors.teal.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.teal.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.teal.shade100;
            break;
        }
        break;
      case 'Personal':
        switch(priority){
          case 'Important':
            activityColor = Colors.indigo.shade500;
            break;
          case 'Mediu':
            activityColor = Colors.indigo.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.indigo.shade100;
            break;
        }
        break;
      case 'Timp liber':
        switch(priority){
          case 'Important':
            activityColor = Colors.purple.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.purple.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.purple.shade100;
            break;
        }
        break;
    }
    
    return activityColor;
  }

  String setRecurrency(String selectedRecurrency, String number)
  {
    //FREQ=DAILY;INTERVAL=1;COUNT=10
    switch(selectedRecurrency){
      case 'Zilnic':
        return 'FREQ=DAILY;COUNT=$number';
      case 'Saptamanal':
        return 'FREQ=WEEKLY;COUNT=$number';
      case 'Lunar':
        return 'FREQ=MONTHLY;COUNT=$number';
    }
    return 'FREQ=DAILY;COUNT=1';
  }

  void saveNewActivity() {
    final isValid = formKey.currentState!.validate();
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    if(isValid) {
      final activity = Activity(
        title: titleController.text, 
        description: detailsController.text, 
        startTime: startDate, 
        endTime: endDate, 
        category: selectCategory, 
        priority: selectPriority, 
        recurency: "",
        // recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=10',
        // setRecurrency(selectRecurrence, recurrencyFreqController.text),
        activityColor: setActivityColor(selectCategory, selectPriority),
        isAllDay: false
        );

        final isEditing = widget.activity != null;

        final provider = Provider.of<ActivityProvider>(context, listen: false);

        if (isEditing){
          provider.editActivity(activity, widget.activity!);
        } else {
          provider.addActivity(activity);
        }

        FirebaseFirestore.instance
            .collection('activities')
            .doc(_firebaseAuth.currentUser!.uid)
            .set({
          'uid': _firebaseAuth.currentUser!.uid,
          'email': _firebaseAuth.currentUser!.email,
          'activity_tile': titleController.text,
          'description': detailsController.text,
          'startTime': startDate,
          'endTime': endDate,
          'category': selectCategory,
          'priority': selectPriority,
          'isAllDay': isChecked
        }, SetOptions(merge: true));

        Navigator.of(context).pop();
    }
    //save to db


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: 
          [IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: saveNewActivity,
          ),]
        ,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              setTitle(),

              SizedBox(height: 25,),

              CheckboxListTile(
                title: Text("Toata ziua"),
                controlAffinity: ListTileControlAffinity.platform,
                value: isChecked, 
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
              SizedBox(height: 25,),
              dateTimePickers(),
              SizedBox(height: 25,),
              setLocation(),
              SizedBox(height: 25,),

              //category
              DropDownField(
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
              SizedBox(height: 25,),
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
              const SizedBox(height: 25,),
              const Text('Reminders setting'),
              const SizedBox(height: 25,),
              setDetails(),
              const SizedBox(height: 25,),
              // setRecurency(),
              // Row(
              //   children: [
              //     DropDownField(
              //       controller: recurrencyController,
              //       hintText: "Recurenta",
              //       enabled: true,
              //       items: recurrencyOptions,
              //       onValueChanged: (value) {
              //         setState(() {
              //           selectRecurrence = value;
              //         });
              //       },
              //     ),
              //     // TextFormField(
              //     //   style: TextStyle(fontSize: 16),
              //     //   decoration: InputDecoration(
              //     //     border: UnderlineInputBorder(),
              //     //     hintText: 'Frecventa recurentei' 
              //     //   ),
              //     //   controller: recurrencyFreqController,
              //     // )
              //   ],
              // ),
              

                           
            ],
            ),
        ),
      )
            
          
    );
  }

  Widget setTitle() => TextFormField(
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Titlu' 
    ),
    onFieldSubmitted: (_) => saveNewActivity(),
    validator: (title) =>
      title != null && title.isEmpty ? 'Activitatea trebuie sa aiba un titlu' : null,
    controller: titleController,
  );

  Widget dateTimePickers() => Column(
    children: [
      buildStarting(),
      buildEnding(),
    ],
  );

  Widget buildStarting () => buildHeader(
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

  Widget buildEnding () => buildHeader(
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
    final date = await pickDateTime(startDate, pickDate: pickDate);

    if(date ==  null) return;

    if(date.isAfter(endDate)) {
      endDate = DateTime(date.year, date.month, date.day, endDate.hour, endDate.minute);
    }

    setState(() => startDate = date);
  }

  Future pickEndingDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      endDate, 
      pickDate: pickDate,
      firstDate: pickDate ? startDate : null
      );

    if(date ==  null) return;

    setState(() => endDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {required bool pickDate, DateTime? firstDate}) async {
      if(pickDate){
        final date = await showDatePicker(
          context: context, 
          initialDate: initialDate, 
          firstDate: firstDate ?? DateTime(2015, 8), 
          lastDate: DateTime(2101)
        );

        if (date == null) return null;

        final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

        return date.add(time);
      }
      else {
        if(!isChecked){
          final timeSelected = await showTimePicker(
          context: context, 
          initialEntryMode: TimePickerEntryMode.input,
          initialTime: TimeOfDay.fromDateTime(initialDate));

        if (timeSelected == null) return null;

        final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
        final time = Duration(hours: timeSelected.hour, minutes: timeSelected.minute);

        return date.add(time);
        }
        
      }
    }

  Widget buildDropdownField ({
    required String text,
    required VoidCallback onClicked
  }) => ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
      child
    ],
  );

  Widget setLocation() => TextFormField(
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Locatie' 
    ),
    controller: locationController,
  );

  Widget setDetails() => TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Descriere' 
    ),
    controller: detailsController,
  );

 }
