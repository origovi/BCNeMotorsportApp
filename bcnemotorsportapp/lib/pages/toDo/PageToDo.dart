import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageToDo extends StatefulWidget {
  final ToDo toDo;
  const PageToDo(this.toDo);

  @override
  _PageToDoState createState() => _PageToDoState();
}

class _PageToDoState extends State<PageToDo> {
  ToDo toDo;

  @override
  void initState() {
    super.initState();
    toDo = widget.toDo;
  }

  void _delete(BuildContext context) {
    Popup.twoOptionsPopup(
      context,
      message: "This ToDo will be deleted forever. Forever is a long time :(",
      text1: "Delete",
      color1: Colors.red,
      onPressed1: () async {
        Popup.loadingPopup(context);
        await Provider.of<CloudDataProvider>(context, listen: false).deleteToDo(this.toDo.id);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        snackDatabaseUpdated(context);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _switchCompleteToDo(BuildContext context) async {
    Popup.loadingPopup(context);
    if (toDo.done) {
      await Provider.of<CloudDataProvider>(context, listen: false).incompleteToDo(this.toDo.id);
      setState(() {
        toDo.incomplete();
      });
    } else {
      await Provider.of<CloudDataProvider>(context, listen: false).completeToDo(this.toDo.id);
      setState(() {
        toDo.complete();
      });
    }
    Navigator.of(context).pop();
    snackDatabaseUpdated(context);
  }

  @override
  Widget build(BuildContext context) {
    //changeSystemUi(statusBrightness: Brightness.dark, milliDelay: 500);
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    List<String> personListNames = toDo.personIds.map((e) => provider.personNameById(e)).toList();
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          tooltip: "Close this page",
          onPressed: Navigator.of(context).pop,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Visibility(
            visible: provider.isTeamLeader || toDo.personIds.contains(provider.dbUId),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: "Edit this ToDo",
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: "Delete this ToDo",
                  onPressed: () => _delete(context),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Visibility(
                    visible: toDo.done,
                    child: Icon(
                      Icons.task_alt,
                      size: 20,
                    ),
                    replacement: SizedBox(
                      width: 20,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    toDo.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        decoration: (toDo.done ? TextDecoration.lineThrough : null)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: toDo.color,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  toDo.importanceName,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(toDo.whenAdded, yearWhenNecessary: true) +
                          (toDo.hasDeadline ? "  -" : ""),
                      style: TextStyle(fontSize: 16),
                    ),
                    if (toDo.hasDeadline)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(toDo.deadline, yearWhenNecessary: true),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "(${toDo.daysUntilDeadline} day${toDo.daysUntilDeadline >= 2 ? "s" : ""} until deadline)",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.group, size: 20),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        Text(
                          "Responsable${personListNames.length >= 2 ? 's' : ''}:",
                          style: TextStyle(fontSize: 16),
                        ),
                      ] +
                      List.generate(
                        personListNames.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              personListNames[index],
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
            if (toDo.hasDescription)
              Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    readOnly: true,
                    controller:
                        TextEditingController.fromValue(TextEditingValue(text: toDo.description)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0.0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 40),
            SizedBox(
              width: 150,
              child: Material(
                borderRadius: BorderRadius.circular(100),
                color: toDo.done ? Colors.blueAccent : Colors.grey[200],
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onLongPress: () => _switchCompleteToDo(context),
                  onTap: () {
                    snackMessage3Secs(context, 'Please hold to switch "complete" state');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: [
                        Icon(
                          toDo.done ? Icons.check_box : Icons.check_box_outline_blank,
                          color: toDo.done ? Colors.white : Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Completed",
                          style: TextStyle(
                              color: toDo.done ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
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
