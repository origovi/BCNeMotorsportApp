import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/PopupMenu.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PageNewEvent extends StatefulWidget {
  PageNewEvent();

  @override
  _PageNewEventState createState() => _PageNewEventState();
}

class _PageNewEventState extends State<PageNewEvent> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode switchFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode tlFocus = FocusNode();
  bool allDay = false;

  void _validateAndSave() {
    if (formKey.currentState.validate()) {
      Navigator.of(context).pop(
        Event(
          name: "prova",
          allDay: allDay,
          color: Colors.white,
          from: DateTime.now(),
          to: DateTime.now(),
          global: false,
        ),
      );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
        brightness: Brightness.dark,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          NiceBox(
            radius: 25,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "  Event data:",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Divider(thickness: 1.5),
                Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                        onFieldSubmitted: (_) => switchFocus.requestFocus(),
                        validator: (value) {
                          if (value.trim().isNotEmpty) {
                            return null;
                          } else
                            return "Person name cannot be empty";
                        },
                        decoration: InputDecoration(
                          //hintText: "This will be fixed for the person's lifetime",
                          //hintStyle: TextStyle(fontSize: 12),
                          labelText: "Name *",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          isDense: true,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12, right: 25, left: 8),
                                child: Icon(Icons.access_time_outlined),
                              ),
                              Expanded(
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("All day"),
                                        Switch(
                                          focusNode: switchFocus,
                                          value: allDay,
                                          onChanged: (newValue) {
                                            setState(() {
                                              allDay = newValue;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("date picker"),
                                        Visibility(visible: !allDay, child: Text("start hour")),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("date picker"),
                                        Visibility(visible: !allDay, child: Text("end hour")),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        focusNode: emailFocus,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) => tlFocus.requestFocus(),
                        validator: (value) {
                          value = value.trim();
                          if (value.isNotEmpty && Functions.validEmail(value)) {
                            if (Provider.of<CloudDataProvider>(context, listen: false)
                                .existsPersonWithEmail(value)) {
                              return "There is already a member with this email";
                            } else
                              return null;
                          } else
                            return "Email is not valid";
                        },
                        decoration: InputDecoration(
                          //hintText: "This will be fixed for the person's lifetime",
                          //hintStyle: TextStyle(fontSize: 12),
                          labelText: "Email *",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          isDense: true,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "  Is Team Leader?",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        focusNode: tlFocus,
                        hint: Text(
                          "Is TL? *",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        value: YesNo.No,
                        decoration: InputDecoration(filled: true),
                        //onTap: FocusScope.of(context).requestFocus,
                        onChanged: (value) {},
                        items: YesNo.options.map((e) {
                          return DropdownMenuItem<String>(value: e, child: Text(e));
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return "Please select";
                          } else {
                            allDay = (value == YesNo.Yes);
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              child: Ink(
                decoration: BoxDecoration(
                  color: TeamColor.teamColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 15,
                    )
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _validateAndSave,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
