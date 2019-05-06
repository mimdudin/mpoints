import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import '../models/employee.dart';

mixin EmployeeService on Model {
  List<Employee> _employeeList = [];
  List<Employee> get employeeList => _employeeList;

  bool _isLoadingEmployee = false;
  bool get isLoadingEmployee => _isLoadingEmployee;

  Future<List<Employee>> fetchAvailableEmployee(
      String partnerId, String partnerPIN) async {
    _isLoadingEmployee = true;
    notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .child("partners_list/$partnerId/employees")
        .orderByChild('PIN')
        .equalTo(partnerPIN)
        .once()
        .then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      print(values);

      final List<Employee> _fetchedEmployees = [];

      if (values != null) {
        values.forEach((key, data) {
          print(key);
          print(data);
          var _employee = new Employee(
            key,
            data['PIN'],
            data['fullName'],
          );
          _fetchedEmployees.add(_employee);
        });
      }

      _employeeList = _fetchedEmployees;

      print(_employeeList.length.toString());

      _isLoadingEmployee = false;
      notifyListeners();
    });
    return _employeeList;
  }

  void clearEmployeeList() {
    _employeeList.clear();
    notifyListeners();
  }
}
