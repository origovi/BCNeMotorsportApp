import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PageNewToDo extends StatefulWidget {
  PageNewToDo();

  @override
  _PageNewToDoState createState() => _PageNewToDoState();
}

class _PageNewToDoState extends State<PageNewToDo> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode;

  TextEditingController nameController;
  TextEditingController descriptionController;

  TextEditingController newPersonController;
  FocusNode newPersonFocus;
  List<Person> possibleNewPersonList;

  FocusNode descriptionFocus;

  bool isTeamLeader;

  bool addingNewPerson;

  DateTime deadline;
  int importanceIndex;
  bool hasDescription;
  bool hasDeadline;
  bool notifyUsers;
  List<Person> personList;

  @override
  void initState() {
    super.initState();
    isTeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    addingNewPerson = false;
    autovalidateMode = AutovalidateMode.disabled;
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    newPersonController = TextEditingController();
    newPersonFocus = FocusNode();
    possibleNewPersonList = [];
    descriptionFocus = FocusNode();
    importanceIndex = ToDo.defImportanceIndex;
    hasDescription = false;
    hasDeadline = false;
    notifyUsers = false;
    personList = [];
  }

  void _validateAndSave() {
    if (formKey.currentState.validate()) {
      ToDo newToDo = ToDo(
        name: nameController.text.trim(),
        hasDeadline: hasDeadline,
        deadline: deadline,
        personIds: [Provider.of<CloudDataProvider>(context, listen: false).dbUId] +
            personList.map((e) => e.dbId).toList(),
        description: descriptionController.text.trim(),
        importanceLevel: importanceIndex,
      );
      Navigator.of(context).pop([newToDo, notifyUsers, personList.map((e) => e.fcmToken).toList()]);
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  // shows color picker popup menu
  void _pickImportance(BuildContext context) {
    Popup.fancyPopup(
      context: context,
      symmetricMargin: true,
      symmetricPadding: true,
      children: List.generate(
        ToDo.importanceNames.length,
        (index) {
          return ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ToDo.colorList[index],
              ),
              width: 20,
              height: 20,
            ),
            title: Text(ToDo.importanceNames[index]),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                importanceIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  void updatePossiblePersonList(String text) {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    List<Person> excludeList = List<Person>.from(personList + [provider.user]);
    setState(() {
      possibleNewPersonList = Provider.of<CloudDataProvider>(context, listen: false)
          .personsThatCoincideCompleteName(text, exclude: excludeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to deselect
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New ToDo"),
          brightness: Brightness.dark,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            Stack(
              children: [
                NiceBox(
                  radius: 25,
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  ToDo data:",
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
                                  return "ToDo name cannot be empty";
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
                            SizedBox(height: 22),
                            Visibility(
                              visible: hasDescription,
                              child: TextField(
                                maxLines: 4,
                                controller: descriptionController,
                                focusNode: descriptionFocus,
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
                                  hintText: "Describe what is needed",
                                ),
                              ),
                              replacement: TextButton(
                                onPressed: () => setState(() {
                                  hasDescription = true;
                                  descriptionFocus.requestFocus();
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
                                      "Add description",
                                      style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 1.5),
                            SizedBox(height: 10),
                            // Importance picker
                            TextButton(
                              onPressed: () => _pickImportance(context),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25, left: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: ToDo.colorList[importanceIndex],
                                      ),
                                      width: 23,
                                      height: 23,
                                    ),
                                  ),
                                  Text(
                                    ToDo.importanceNames[importanceIndex],
                                    style: TextStyle(
                                        color: Colors.black, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 1.5),
                            SizedBox(height: 10),
                            // Deadline
                            TextButton(
                              onLongPress: hasDeadline
                                  ? () {
                                      setState(() {
                                        hasDeadline = false;
                                      });
                                      snackMessage3Secs(context, "Deadline removed");
                                    }
                                  : null,
                              onPressed: () async {
                                DateTime ret = await pickDate(
                                  context,
                                  initialDate: deadline ?? DateTime.now().add(Duration(days: 1)),
                                  firstDate: DateTime.now().add(Duration(days: 1)),
                                );
                                if (ret != null) {
                                  setState(() {
                                    hasDeadline = true;
                                    deadline = ret;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25, left: 8),
                                    child: Icon(Icons.date_range, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    !hasDeadline
                                        ? "Add deadline"
                                        : "Deadline: ${formatEventDate(deadline)}",
                                    style: TextStyle(
                                        color: Colors.black, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 1.5),
                            SizedBox(height: 10),
                            // Members
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: (!addingNewPerson && personList.isEmpty)
                                        ? () {
                                            setState(() {
                                              addingNewPerson = true;
                                            });
                                            newPersonFocus.requestFocus();
                                          }
                                        : null,
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 25, left: 8),
                                          child: Icon(Icons.group, color: Colors.grey[600]),
                                        ),
                                        Text(
                                          (!addingNewPerson && personList.isEmpty)
                                              ? "Add person"
                                              : "Persons: ",
                                          style: TextStyle(
                                              color: Colors.black, fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (personList.isNotEmpty)
                                  TextButton(
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_add, color: Colors.grey[600]),
                                        SizedBox(width: 5),
                                        Text("Add person",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    onPressed: () {
                                      setState(() {
                                        addingNewPerson = true;
                                      });
                                      newPersonFocus.requestFocus();
                                    },
                                  )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 57),
                              child: Column(
                                children: [
                                  Column(
                                    children: List.generate(
                                      personList.length,
                                      (index) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(personList[index].completeName),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        personList.removeAt(index);
                                                        if (personList.isEmpty) notifyUsers = false;
                                                      });
                                                    },
                                                    icon: Icon(Icons.clear))
                                              ],
                                            ),
                                            if (index != personList.length - 1) Divider(),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  if (addingNewPerson)
                                    TextField(
                                      focusNode: newPersonFocus,
                                      controller: newPersonController,
                                      onChanged: (value) => updatePossiblePersonList(value.trim()),
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                        //hintText: "This will be fixed for the person's lifetime",
                                        //hintStyle: TextStyle(fontSize: 12),
                                        hintText: "Name",
                                        hintStyle: TextStyle(fontSize: 12),
                                        contentPadding: EdgeInsets.only(left: 12),
                                        suffix: TextButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            setState(() {
                                              addingNewPerson = false;
                                            });
                                          },
                                        ),
                                        isDense: true,
                                        filled: true,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (personList.isNotEmpty)
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Divider(thickness: 1.5),
                                  SizedBox(height: 10),
                                  // Notification
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        notifyUsers = !notifyUsers;
                                      });
                                    },
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 25, left: 8),
                                          child: Icon(
                                              notifyUsers
                                                  ? Icons.notifications_active
                                                  : Icons.notifications,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          "Notify users now?",
                                          style: TextStyle(
                                              color: Colors.black, fontWeight: FontWeight.normal),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: personList.isEmpty ? 70 : 155,
                    left: 78,
                    child: Visibility(
                      visible: addingNewPerson &&
                          newPersonController.text.trim().isNotEmpty &&
                          possibleNewPersonList.isNotEmpty,
                      child: Container(
                        width: 250,
                        height: 100,
                        child: Card(
                          elevation: 5,
                          child: ListView.builder(
                            reverse: true,
                            itemCount: possibleNewPersonList.length,
                            itemBuilder: (context, possiblePersonIndex) {
                              return InkWell(
                                onTap: () {
                                  newPersonFocus.unfocus();
                                  setState(() {
                                    personList.add(possibleNewPersonList[possiblePersonIndex]);
                                    addingNewPerson = false;
                                    newPersonController.clear();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(possibleNewPersonList[possiblePersonIndex].completeName),
                                      Text(
                                        possibleNewPersonList[possiblePersonIndex].email,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )),
              ],
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
    descriptionController.dispose();
    newPersonController.dispose();
    newPersonFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }
}
