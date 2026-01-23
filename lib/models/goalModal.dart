
class GoalModal {
  GoalModal({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.hardFocus,
    required this.blockScreen,
    this.description,
    List<String >? appsNotAllowed ,
  }):appsNotAllowed = appsNotAllowed ?? [];

  final DateTime id;
  String title;
  DateTime startDate;
  DateTime endDate;
  bool hardFocus;
  bool blockScreen;
  String? description;
  List<String> appsNotAllowed;








  Map<String, dynamic> toJson() => {"id": id.toIso8601String(),"title": title,  "startDate": startDate.toIso8601String(), "endDate":  endDate.toIso8601String(), "hardFocus": hardFocus,"description":description,"blockScreen":blockScreen,"appsNotAllowed": appsNotAllowed};

  factory GoalModal.fromJson(Map<String, dynamic> json){
    return GoalModal(id:DateTime.parse( json["id"]),title: json["title"],  startDate:DateTime( json["startDate"]), endDate:DateTime( json["endDate"]),hardFocus: json["hardFocus"], description: json["description"], blockScreen: json["blockScreen"],appsNotAllowed: json["appsNotAllowed"]);
  }
}
