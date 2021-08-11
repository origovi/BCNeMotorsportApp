import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/services/StorageService.dart';
import 'package:bcnemotorsportapp/widgets/Buttons.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:bcnemotorsportapp/widgets/ShowImage.dart';
import 'package:bcnemotorsportapp/widgets/team/SectionGrid.dart';
import 'package:bcnemotorsportapp/widgets/team/Stat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ScreenMember extends StatefulWidget {
  final Person person;
  final void Function(void Function()) _setStateParent;
  final bool isMe;

  ScreenMember(this.person, this._setStateParent, {@required this.isMe});

  @override
  _ScreenMemberState createState() => _ScreenMemberState();
}

class _ScreenMemberState extends State<ScreenMember> {
  List<String> _chiefSectionsId;
  List<String> _onlyMemberSectionsId;

  bool _hasAbout;
  bool _aboutCanSaveAgain;
  TextEditingController _noteController;
  FocusNode _aboutFocus;
  String _newTempAbout;

  @override
  void initState() {
    super.initState();

    _chiefSectionsId = widget.person.chiefSectionIds;
    _onlyMemberSectionsId = widget.person.onlyMemberSectionIds;

    _hasAbout = widget.person.hasAbout;
    _aboutCanSaveAgain = true;
    if (_hasAbout)
      _noteController = TextEditingController.fromValue(TextEditingValue(text: widget.person.about));
    else
      _noteController = TextEditingController();
    _aboutFocus = FocusNode();
  }

  Future<void> _saveAbout() async {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    await Future.delayed(Duration(seconds: 3));
    widget.person.about = _newTempAbout;
    await provider.updatePersonAbout(widget.person.dbId, _newTempAbout);
    //snackDatabaseUpdated(context);
    _aboutCanSaveAgain = true;
  }

  Future<void> _updateProfileImage(BuildContext context) async {
    PickedFile image = await pickGalleryImage();
    if (image != null) {
      await StorageService.uploadProfileImage(image, widget.person.profilePhotoName);
      snackDatabaseUpdated(context);
      widget._setStateParent(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to deselect the about note when clicking outside
      onTap: () => _aboutFocus.unfocus(),
      child: ListView(
        padding:
            EdgeInsets.only(top: Sizes.sideMargin, right: Sizes.sideMargin, left: Sizes.sideMargin),
        children: [
          NiceBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowImage(
                  widget.person.profilePhotoName,
                  size: 80,
                  displayable: true,
                  displayTitle: widget.person.completeName,
                  displayActions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.edit), onPressed: () => _updateProfileImage(context)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.person.completeName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.person.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Stat('ToDos Completed', widget.person.toDosCompleted)],
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: _hasAbout,
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    child: TextField(
                      readOnly: !widget.isMe,
                      maxLines: 2,
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
                  replacement: Visibility(
                    visible: widget.isMe,
                    child: Center(
                      child: FlatIconButton(
                        text: "Add About",
                        onPressed: () {
                          setState(() {
                            _aboutFocus.requestFocus();
                            _hasAbout = true;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // CHIEF SECTIONS
          Visibility(
            visible: _chiefSectionsId.length > 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 3),
                  child: Text(
                    "CHIEF OF",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SectionGrid(
                  data: Provider.of<CloudDataProvider>(context, listen: false).sectionsData,
                  desiredSections: _chiefSectionsId,
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
          // MEMBER SECTIONS
          Visibility(
            visible: _onlyMemberSectionsId.length > 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 3),
                  child: Text(
                    "MEMBER OF",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SectionGrid(
                  data: Provider.of<CloudDataProvider>(context, listen: false).sectionsData,
                  desiredSections: _onlyMemberSectionsId,
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
