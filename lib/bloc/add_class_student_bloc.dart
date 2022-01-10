import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/services/class_student_services.dart';

class AddClassStudentBloC extends BaseBloC {
  static final AddClassStudentBloC _instance = AddClassStudentBloC._();
  AddClassStudentBloC._() {
    _classStudentServices = ClassServices();
  }

  static AddClassStudentBloC getInstance() {
    return _instance;
  }

  late ClassServices _classStudentServices;
  late ClassStudent _classStudent;

  StreamController<bool> _saveButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get saveButtonState => _saveButtonController.stream;

  set nameClass(String value) {
    _classStudent.nameClass = value.trim();
    _saveButtonController.sink.add(_classStudent.isFullInformation());
  }

  set studentNumber(String value) {
    _classStudent.studentNumber = value.trim();
    _saveButtonController.sink.add(_classStudent.isFullInformation());
  }

  set achievements(String value) {
    _classStudent.achievements = value.trim();
    _saveButtonController.sink.add(_classStudent.isFullInformation());
  }

  set classMonitor(String value) {
    _classStudent.classMonitor = value.trim();
    _saveButtonController.sink.add(_classStudent.isFullInformation());
  }

  Future<bool> addClassStudent() async {
    showLoading();
    bool result = await _classStudentServices.addClassStudent(_classStudent);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonController.sink.add(false);
    _classStudent = ClassStudent();
  }

  @override
  void dispose() {
    _saveButtonController.close();
    super.dispose();
  }
}
