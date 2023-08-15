import 'package:flutter/material.dart';

class NewActivityPage extends StatefulWidget {
  
  const NewActivityPage({super.key});

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {

  void saveNewActivity() {
    //save to db
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () =>  Navigator.pop(context),
            ),
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: saveNewActivity,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 25,
            ),
            const Icon(
              Icons.calendar_month,
              size: 100,
            ),

            const SizedBox(
              height: 25,
            ),
            Text(
              'Activitate noua',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            // username textfield
            
          ]),
        )),
      ),
    );
  }
}
