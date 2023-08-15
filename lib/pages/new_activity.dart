import 'package:flutter/material.dart';
import 'package:organizare_timp/components/textfields.dart';
import 'package:organizare_timp/components/utils.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:provider/provider.dart';

import '../provider/activity_provider.dart';

class NewActivityPage extends StatefulWidget {

  final Activity? activity;
  
  const NewActivityPage({Key? key, this.activity,}) : super(key: key);

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  final formKey = GlobalKey<FormState>();
  late DateTime startDate;
  late DateTime endDate;

  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.activity == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 1));
    }
  }

  void saveNewActivity() {
    final isValid = formKey.currentState!.validate();

    if(isValid) {
      final activity = Activity(
        title: titleController.text, 
        description: 'description', 
        startTime: startDate, 
        endTime: endDate, 
        category: 'category', 
        priority: 'priority', 
        recurency: 'recurency',
        isAllDay: false
        );

        final provider = Provider.of<ActivityProvider>(context, listen: false);
        provider.addActivity(activity);

        Navigator.of(context).pop();
    }
    //save to db
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: 
          // [IconButton(
          //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
          //   onPressed: () =>  Navigator.pop(context),
          //   ),
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
              dateTimePickers(),

              
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
        final timeSelected = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.fromDateTime(initialDate));

        if (timeSelected == null) return null;

        final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
        final time = Duration(hours: timeSelected.hour, minutes: timeSelected.minute);

        return date.add(time);
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

 }
