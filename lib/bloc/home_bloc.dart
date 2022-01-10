import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/services/class_student_services.dart';

class HomeBloC extends BaseBloC {
  static final HomeBloC _instance = HomeBloC._();
  HomeBloC._() {
    _classStudentServices = ClassServices();
  }

  static HomeBloC getInstance() {
    return _instance;
  }

  late ClassServices _classStudentServices;

  StreamController<List<ClassStudent>> _listClassStudentController =
      StreamController<List<ClassStudent>>.broadcast();

  Stream<List<ClassStudent>> get listClassStudentStream => _listClassStudentController.stream;

  Future<List<ClassStudent>> getListClassStudent() async {
    List<ClassStudent> list = await _classStudentServices.getListClass();
    _listClassStudentController.sink.add(list);
    return list;
  }

  Future<bool> deleteClassStudent(ClassStudent classStudent) async {
    bool deleteSuccess = await _classStudentServices.deleteClassStudent(classStudent);
    await getListClassStudent();
    return deleteSuccess;
  }

  @override
  void clearData() {}

  @override
  void dispose() {
    _listClassStudentController.close();
    super.dispose();
  }
}
