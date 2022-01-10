

class ClassStudent {
  String? nameClass;
  String? studentNumber;
  String? achievements;
  String? classMonitor;

  ClassStudent(
      {this.nameClass,
      this.studentNumber,
      this.achievements,
      this.classMonitor});

  ClassStudent.fromJson(Map<String, dynamic> json) {
    nameClass = json['nameClass'];
    studentNumber = json['studentNumber'];
    achievements = json['achievements'];
    classMonitor = json['classMonitor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameClass'] = this.nameClass;
    data['studentNumber'] = this.studentNumber;
    data['achievements'] = this.achievements;
    data['classMonitor'] = this.classMonitor;
    return data;
  }

  bool isFullInformation() {
    if (nameClass == null ||
        studentNumber == null ||
        achievements == null ||
        classMonitor == null
) {
      return false;
    }
    return 
        nameClass!.isNotEmpty &&
        studentNumber!.isNotEmpty &&
        achievements!.isNotEmpty &&
        classMonitor!.isNotEmpty;
  }
}
