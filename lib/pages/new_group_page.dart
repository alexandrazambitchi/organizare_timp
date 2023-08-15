import 'package:flutter/material.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //nume grup
      //membri - multiple drop down selection/search in db?
      //descriere
      
    );
  }
}