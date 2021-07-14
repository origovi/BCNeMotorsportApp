import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
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

  AutovalidateMode autovalidateMode;

  TextEditingController nameController;
  TextEditingController _noteController;

  FocusNode noteFocus;

  bool isTeamLeader;

  DateTime fromDate, toDate;
  int colorIndex;
  bool allDay;
  bool global;
  bool noteCreated;
  bool notifyUsers;
  Section selectedSectionVisible;

  @override
  void initState() {
    super.initState();
    isTeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    autovalidateMode = AutovalidateMode.disabled;
    nameController = TextEditingController();
    _noteController = TextEditingController();
    noteFocus = FocusNode();
    fromDate = DateTime.now();
    toDate = fromDate.add(Duration(hours: 1));
    colorIndex = Event.defColorIndex;
    allDay = false;
    global = false;
    noteCreated = false;
    notifyUsers = false;
  }

  void _validateAndSave() {
    if (formKey.currentState.validate()) {
      if (!global && selectedSectionVisible == null) {
        Popup.errorPopup(context, "Please select visibility for the event.");
      } else {
        Event newEvent = Event(
          name: nameController.text.trim(),
          allDay: allDay,
          color: Event.colorList[colorIndex],
          from: fromDate,
          to: toDate,
          global: global,
          sectionId: selectedSectionVisible == null ? null : selectedSectionVisible.sectionId,
          note: _noteController.text.trim(),
        );
        Navigator.of(context).pop([newEvent, notifyUsers]);
      }
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  // shows color picker popup menu
  void _pickColor(BuildContext context) {
    Popup.fancyPopup(
      context: context,
      symmetricMargin: true,
      symmetricPadding: true,
      children: List.generate(
        Event.colorList.length,
        (index) {
          return ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Event.colorList[index],
              ),
              width: 20,
              height: 20,
            ),
            title: Text(Event.colorNames[index]),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                colorIndex = index;
              });
            },
          );
        },
      ),
    );
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
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              return null;
                            } else
                              return "Event name cannot be empty";
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
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12, right: 25, left: 8),
                                  child: Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            allDay = !allDay;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          primary: Colors.black,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("All day"),
                                            Switch(
                                              value: allDay,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  allDay = newValue;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      // INITIAL DATE
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            child: Text(formatEventDate(fromDate)),
                                            onPressed: () async {
                                              DateTime ret =
                                                  await pickDate(context, initialDate: fromDate);
                                              if (ret != null) {
                                                if (ret.isAfter(toDate) ||
                                                    ret.isAtSameMomentAs(toDate))
                                                  setState(() {
                                                    fromDate = ret;
                                                    toDate = ret.add(Duration(hours: 1));
                                                  });
                                                else
                                                  setState(() {
                                                    fromDate = ret;
                                                  });
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              primary: Colors.black,
                                            ),
                                          ),
                                          Visibility(
                                            visible: !allDay,
                                            child: TextButton(
                                              child: Text(formatEventTime(fromDate)),
                                              onPressed: () async {
                                                DateTime ret = await pickTime(context, fromDate);
                                                if (ret.isAfter(toDate) ||
                                                    ret.isAtSameMomentAs(toDate))
                                                  setState(() {
                                                    fromDate = ret;
                                                    toDate = ret.add(Duration(minutes: 1));
                                                  });
                                                else
                                                  setState(() {
                                                    fromDate = ret;
                                                  });
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                primary: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // END DATE
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            child: Text(formatEventDate(toDate)),
                                            onPressed: () async {
                                              DateTime ret =
                                                  await pickDate(context, initialDate: toDate);
                                              if (ret != null) {
                                                if (ret.isBefore(fromDate) ||
                                                    ret.isAtSameMomentAs(fromDate))
                                                  setState(() {
                                                    toDate = ret;
                                                    fromDate = ret.subtract(Duration(hours: 1));
                                                  });
                                                else
                                                  setState(() {
                                                    toDate = ret;
                                                  });
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              primary: Colors.black,
                                            ),
                                          ),
                                          Visibility(
                                            visible: !allDay,
                                            child: TextButton(
                                              child: Text(formatEventTime(toDate)),
                                              onPressed: () async {
                                                DateTime ret = await pickTime(context, toDate);
                                                if (ret.isBefore(fromDate) ||
                                                    ret.isAtSameMomentAs(fromDate))
                                                  setState(() {
                                                    toDate = ret;
                                                    fromDate = ret.subtract(Duration(minutes: 1));
                                                  });
                                                else
                                                  setState(() {
                                                    toDate = ret;
                                                  });
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                primary: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 1.5),
                        SizedBox(height: 10),
                        // Color picker
                        TextButton(
                          onPressed: () => _pickColor(context),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Event.colorList[colorIndex],
                                  ),
                                  width: 23,
                                  height: 23,
                                ),
                              ),
                              Text(
                                Event.colorNames[colorIndex],
                                style:
                                    TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 1.5),
                        SizedBox(height: 10),
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
                                child: Icon(
                                    notifyUsers ? Icons.notifications_active : Icons.notifications,
                                    color: Colors.grey[600]),
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
                        SizedBox(height: 10),
                        Divider(thickness: 1.5),
                        SizedBox(height: 10),

                        Visibility(
                          visible: noteCreated,
                          child: TextField(
                            maxLines: 4,
                            controller: _noteController,
                            focusNode: noteFocus,
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
                              hintText: "Write some notes",
                            ),
                          ),
                          replacement: TextButton(
                            onPressed: () => setState(() {
                              noteCreated = true;
                              noteFocus.requestFocus();
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
                                  "Add note",
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
}
