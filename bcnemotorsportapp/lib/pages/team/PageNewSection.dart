import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PageNewSection extends StatefulWidget {
  PageNewSection();

  @override
  _PageNewSectionState createState() => _PageNewSectionState();
}

class _PageNewSectionState extends State<PageNewSection> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode;

  TextEditingController nameController, aboutController;

  FocusNode aboutFocus;

  bool isTeamLeader;
  bool hasAbout;

  @override
  void initState() {
    super.initState();
    isTeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    autovalidateMode = AutovalidateMode.disabled;
    nameController = TextEditingController();
    aboutController = TextEditingController();
    aboutFocus = FocusNode();
    hasAbout = false;
  }

  void _validateAndSave() {
    if (formKey.currentState.validate()) {
      Navigator.of(context).pop(
        Section(
          name: nameController.text.trim(),
          about: aboutController.text.trim(),
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
    return GestureDetector(
      // used to deselect
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Section"),
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
                    "  Section data:",
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
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            value = value.trim();
                            if (value.isNotEmpty) {
                              if (Provider.of<CloudDataProvider>(context, listen: false)
                                  .existsSectionWithName(value)) {
                                return "There is already a section with this name";
                              } else
                                return null;
                            } else
                              return "Section name cannot be empty";
                          },
                          onFieldSubmitted: (_) => aboutFocus.requestFocus(),
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
                        SizedBox(height: 20),
                        Visibility(
                          visible: hasAbout,
                          child: TextField(
                            maxLines: 4,
                            controller: aboutController,
                            focusNode: aboutFocus,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0.0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              hintText: "Describe what the section does",
                            ),
                          ),
                          replacement: TextButton(
                            onPressed: () => setState(() {
                              hasAbout = true;
                              aboutFocus.requestFocus();
                            }),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25, left: 8),
                                  child: Icon(Icons.notes, color: Colors.grey[600]),
                                ),
                                Text(
                                  "Add about",
                                  style:
                                      TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 30),
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
                        "Create",
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
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    aboutFocus.dispose();
    super.dispose();
  }
}
