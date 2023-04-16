class DataModel {
  int? id;
  String fullname;
  String password;
  String email;

  DataModel({this.id, required this.fullname, required this.password, required this.email});

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
      id: json['id'], fullname: json["fullname"], password: json["password"], email: json["email"]);

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstname": fullname,
    "password": password,
    "email":  email,
  };


  factory DataModel.fromJson(Map<dynamic, dynamic> json) {
    return DataModel(
      id: json['id'],
      fullname: json['fullname'],
      password: json['password'],
      email: json['email'],
    );
  }
}
