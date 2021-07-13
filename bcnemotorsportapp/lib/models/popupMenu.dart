class TeamScreenPopupMenu {
  static const String config = "Config";
  static const String logout = "Logout";

  static const List<String> choices = [config, logout];
}

class TeamScreenMemberTilePopupMenu {
  static const String changeRole = "Change Role";
  static const String sendEmail = "Send Email";

  static const List<String> choicesOwn = [changeRole, sendEmail];
  static const List<String> choices = [sendEmail];
}

class TeamScreenEdit {
  static const String manageAccess = "Manage Access";
  static const String manageSections = "Manage Sections";

  static const List<String> choices = [manageAccess, manageSections];
}

class YesNo {
    static const String yes = "Yes";
    static const String no = "No";

    static const List<String> options = [yes, no];
}

class SortToDo {
  static const String ascending = "Biggest amount first";
  static const String descending = "Smallest amount first";
  static const String newest = "Newest first";
  static const String oldest = "Oldest first";
  static const String modified = "Recently modified first";

  static const List<String> choices = [ascending, descending, newest, oldest, modified];
}

class NewCalendar {
    static const String newEvent = "New Event";
    static const String newAnnouncement = "New Announcement";

    static const List<String> choices = [newEvent, newAnnouncement];
}

class AnnouncementPopupMenu {
  static const String delete = "Delete Announcement";

  static const List<String> choices = [delete];
}