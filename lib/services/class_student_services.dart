import 'dart:convert';

import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/services/file_services.dart';
import 'package:flutter/services.dart';

//ghi các thông tin của student trong file students.json
class ClassServices extends FileServices {
  final String fileName = 'classstudent.json';

  ///lấy data student từ file [phonebooks.json]
  ///trả về default data từ assets nếu không có dữ liệu từ file
  Future<List<ClassStudent>> getListClass() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<ClassStudent>((e) => ClassStudent.fromJson(e)).toList();
    } catch (error) {
      String studentData =
          await rootBundle.loadString('assets/json/class_student_data.json');
      await writeData(fileName, studentData);
      List jsonData = json.decode(studentData);
      return jsonData.map<ClassStudent>((e) => ClassStudent.fromJson(e)).toList();
    }
  }

  Future<bool> addClassStudent(ClassStudent classStudent) async {
    List<ClassStudent> listUser = await getListClass();
    int index = listUser
        .indexWhere((element) => element.studentNumber == classStudent.studentNumber);
    listUser.insert(0, classStudent);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deleteClassStudent(ClassStudent classStudent) async {
    List<ClassStudent> listUser = await getListClass();
    int index = listUser
        .indexWhere((element) => element.studentNumber == classStudent.studentNumber);
    listUser.removeAt(index);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> editClassStudent(ClassStudent classStudent) async {
    List<ClassStudent> listUser = await getListClass();
    int index = listUser
        .indexWhere((element) => element.studentNumber == classStudent.studentNumber);
    listUser[index] = classStudent;
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
