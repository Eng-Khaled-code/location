import 'package:location/models/user_model.dart';

UserModel? userModel;

class GlobalVariables {
  static List<String> filterList = [
    "الكل",
    "بحث",
    "${DateTime.now().month}",
    DateTime.now().year.toString()
  ];

  static const String fireaseMessagingServerKey =
      "key=AAAA0hPtuGM:APA91bFYV9vlomLxWpx9lcXPupZNrVyVG-bxdkoB2wI73DnOh39Ef1ReNQWFNSJL-I3cptLqJMqJIaWcTrX6eShVTFC0yCAARl4cbjaA6RoIbLQj5btNmq4tXIGFhkfqbxdBXf2iJVXM";
}
