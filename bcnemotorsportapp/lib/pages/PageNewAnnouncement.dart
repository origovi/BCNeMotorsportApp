import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PageNewAnnouncement extends StatefulWidget {
  PageNewAnnouncement();

  @override
  _PageNewAnnouncementState createState() => _PageNewAnnouncementState();
}

class _PageNewAnnouncementState extends State<PageNewAnnouncement> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode;

  TextEditingController titleController, bodyController;

  FocusNode bodyFocus;

  bool isTeamLeader;

  bool global;
  bool notifyUsers;
  Section selectedSectionVisible;

  @override
  void initState() {
    super.initState();
    isTeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    autovalidateMode = AutovalidateMode.disabled;
    titleController = TextEditingController();
    bodyController = TextEditingController();
    bodyFocus = FocusNode();
    global = false;
    notifyUsers = false;
  }

  void _validateAndSave() {
    if (formKey.currentState.validate()) {
      if (!global && selectedSectionVisible == null) {
        Popup.errorPopup(context, "Please select visibility for the announcement.");
      } else {
        Announcement newAnnouncement = Announcement(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
          global: global,
          sectionId: selectedSectionVisible == null ? null : selectedSectionVisible.sectionId,
        );
        Navigator.of(context).pop([newAnnouncement, notifyUsers]);
      }
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  // shows visibility popup menu
  void _changeVisibility(BuildContext context) {
    List<Section> sections;
    if (isTeamLeader)
      sections = Provider.of<CloudDataProvider>(context, listen: false).allSections;
    else
      sections = Provider.of<CloudDataProvider>(context, listen: false).userChiefSections;
    Popup.fancyPopup(
      context: context,
      symmetricPadding: true,
      children: [
        Visibility(
          visible: isTeamLeader,
          child: Column(
            children: [
              ListTile(
                title: Text("Everyone"),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    global = true;
                  });
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "  Your sections:",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Divider(thickness: 1.5),
        Container(
          height: 150,
          child: ListView(
            children: List.generate(
              sections.length,
              (index) {
                return ListTile(
                  title: Text(sections[index].name),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      global = false;
                      selectedSectionVisible = sections[index];
                    });
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to deselect
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Announcement"),
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
                    "  Announcement data:",
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
                          controller: titleController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              return null;
                            } else
                              return "Announcement title cannot be empty";
                          },
                          onFieldSubmitted: (_) => bodyFocus.requestFocus(),
                          decoration: InputDecoration(
                            //hintText: "This will be fixed for the person's lifetime",
                            //hintStyle: TextStyle(fontSize: 12),
                            labelText: "Title *",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            isDense: true,
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          controller: bodyController,
                          focusNode: bodyFocus,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              return null;
                            } else
                              return "Announcement body cannot be empty";
                          },
                          decoration: InputDecoration(
                            //hintText: "This will be fixed for the person's lifetime",
                            //hintStyle: TextStyle(fontSize: 12),
                            labelText: "Body *",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            isDense: true,
                            filled: true,
                          ),
                        ),

                        SizedBox(height: 22),
                        // Visibility
                        TextButton(
                          onPressed: () => _changeVisibility(context),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 8),
                                child: Icon(Icons.visibility, color: Colors.grey[600]),
                              ),
                              Text(
                                global
                                    ? "Visible for everyone"
                                    : (selectedSectionVisible == null
                                        ? "Select Visibility *"
                                        : selectedSectionVisible.name),
                                style:
                                    TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 1.5),
                        SizedBox(height: 10),
                        // Notification
                        TextButton(
                          onPressed: () => setState(() {
                            notifyUsers = !notifyUsers;
                          }),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 8),
                                child: Icon(notifyUsers ? Icons.notifications_active : Icons.notifications, color: Colors.grey[600]),
                              ),
                              Text(
                                "Notify users now?",
                                style:
                                    TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                              ),
                              Spacer(),
                              Switch(
                                value: notifyUsers,
                                onChanged: (val) {
                                  setState(() {
                                    notifyUsers = val;
                                  });
                                },
                              ),
                            ],
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
    titleController.dispose();
    bodyController.dispose();
    bodyFocus.dispose();
    super.dispose();
  }
}
