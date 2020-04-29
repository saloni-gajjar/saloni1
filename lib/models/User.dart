class User {
  //final String id;
  final String fullName;
  final String email;
  final String userRole;
  final String emp_id;
  final String phone_number;
  final String vehicle_number;
  final String license_number;

  User(
      {this.fullName, this.email, this.userRole, this.emp_id, this.phone_number, this.vehicle_number, this.license_number});

  User.fromData(Map<String, dynamic> data)
      : //id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        emp_id = data['Employee ID'],
        phone_number = data['Phone Number'],
        vehicle_number = data['Vehicle Number'],
        license_number = data['Driving License Number'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'Employee ID': emp_id,
      'Phone Number': phone_number,
      'Vehicle Number': vehicle_number,
      'Driving License Number': license_number,
    };
  }
}
