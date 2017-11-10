class Salon {
  String name;
  String address;
  String hours;
  String phone;

  Salon.fromJson(Map json) {
    if ( json != null ) {
      name = json['name'];
      address = json['address'];
      hours = json['hours'];
      phone = json['phone'];
    }
  }
}

