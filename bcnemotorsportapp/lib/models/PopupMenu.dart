class TeamScreenPopupMenu {
  static const String Config = "Config";
  static const String Logout = "Logout";

  static const List<String> choices = [Config, Logout];
}

class TeamScreenMemberTilePopupMenu {
  static const String ChangeRole = "Change Role";
  static const String SendEmail = "Send Email";

  static const List<String> choicesOwn = [ChangeRole, SendEmail];
  static const List<String> choices = [SendEmail];
}

class TeamScreenEdit {
  static const String ManageAccess = "Manage Access";
  static const String ManageSections = "Manage Sections";

  static const List<String> choices = [ManageAccess, ManageSections];
}

class YesNo {
    static const String Yes = "Yes";
    static const String No = "No";

    static const List<String> options = [Yes, No];
}

class SortToDo {
  static const String Ascending = "Biggest amount first";
  static const String Descending = "Smallest amount first";
  static const String Newest = "Newest first";
  static const String Oldest = "Oldest first";
  static const String Modified = "Recently modified first";

  static const List<String> choices = [Ascending, Descending, Newest, Oldest, Modified];
}