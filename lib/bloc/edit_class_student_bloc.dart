import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/services/class_student_services.dart';

class EditClassStudentBloC extends BaseBloC {
  static final EditClassStudentBloC _instance = EditClassStudentBloC._();
  EditClassStudentBloC._() {
     _classStudentServices = ClassServices();
  }

  static EditClassStudentBloC getInstance() {
    return _instance;
  }

  late ClassServices _classStudentServices;
  late ClassStudent _classStudent;

  set classStudent(ClassStudent value) {
    _classStudent = value;
  }

  set nameClass(String nameClass) {
    _classStudent.nameClass = nameClass;
  }

  set studentNumber(String studentNumber) {
    _classStudent.studentNumber = studentNumber;
  }

  set achievements(String achievements) {
    _classStudent.achievements = achievements;
  }

  set classMonitor(String classMonitor) {
    _classStudent.classMonitor = classMonitor;
  }

  Future<bool> updateClassStudent() async {
    showLoading();
    bool result = await _classStudentServices.editClassStudent(_classStudent);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
