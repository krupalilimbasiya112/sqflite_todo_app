class DataModal {
  int? id;
  String? name;
  String? email;
  String? password;

  DataModal({this.id, this.email, this.password, this.name});

  Map<String,dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
    };
  }

  factory DataModal.fromMap( Map<String,dynamic> data){
    return DataModal(id: data['id'],name: data['name'],email: data['email'], password: data['password']);
  }
}