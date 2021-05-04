import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/services/StorageService.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:bcnemotorsportapp/widgets/ShowImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ScreenMe extends StatefulWidget {
  final Person _me;
  final void Function(void Function()) _setStateParent;

  ScreenMe(this._me, this._setStateParent);

  @override
  _ScreenMeState createState() => _ScreenMeState();
}

class _ScreenMeState extends State<ScreenMe> {
  bool _hasAbout;
  bool _aboutCanSaveAgain;
  TextEditingController _noteController;
  FocusNode _aboutFocus;
  String _newTempAbout;

  @override
  void initState() {
    super.initState();
    _hasAbout = widget._me.hasAbout;
    _aboutCanSaveAgain = true;
    if (_hasAbout)
      _noteController = TextEditingController.fromValue(TextEditingValue(text: widget._me.about));
    else
      _noteController = TextEditingController();
    _aboutFocus = FocusNode();
  }

  Future<void> _saveAbout() async {
    await Future.delayed(Duration(seconds: 3));
    await Provider.of<CloudDataProvider>(context, listen: false)
        .updatePersonAbout(widget._me.dbId, _newTempAbout);
    //snackDatabaseUpdated(context);
    _aboutCanSaveAgain = true;
  }

  Future<void> _updateProfileImage(BuildContext context) async {
    PickedFile image = await pickGalleryImage();
    if (image != null) {
      await StorageService.uploadProfileImage(image, widget._me.dbId + '.jpg');
      snackDatabaseUpdated(context);
      widget._setStateParent(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to deselect the about note when clicking outside
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ListView(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        children: [
          NiceBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowImage(
                  widget._me.dbId + '.jpg',
                  size: 80,
                  displayable: true,
                  displayTitle: widget._me.completeName,
                  displayActions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.edit), onPressed: () => _updateProfileImage(context)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget._me.completeName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget._me.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: _hasAbout,
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    elevation: 5.0,
                    child: TextField(
                      controller: _noteController,
                      focusNode: _aboutFocus,
                      onChanged: (text) {
                        _newTempAbout = text.trim();
                        if (_aboutCanSaveAgain) {
                          _aboutCanSaveAgain = false;
                          _saveAbout();
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        hintText: "Which are your hobbies?",
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_hasAbout,
                  child: Center(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text(" Add About"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _aboutFocus.requestFocus();
                          _hasAbout = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: TextButton(
              child: Text("edede"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}