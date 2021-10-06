class TodoModel {
  String? name;
  bool? checked;

  TodoModel({this.name, this.checked});

  TodoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        checked = json['checked'];

  Map<String, dynamic> toJson() => {'name': name, 'checked': checked};

}