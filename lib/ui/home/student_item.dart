import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/ui/home/edit_class_students_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassStudentItem extends StatefulWidget {
  final Animation<double> animation;
  final ClassStudent classStudent;
  final Function()? onRemoved;
  const ClassStudentItem(
      {Key? key,
      required this.classStudent,
      required this.animation,
      this.onRemoved})
      : super(key: key);

  @override
  _ClassStudentItemState createState() => _ClassStudentItemState();
}

class _ClassStudentItemState extends State<ClassStudentItem> {
  late ClassStudent classStudent;
  @override
  void initState() {
    classStudent = widget.classStudent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      axis: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xff141A1A1A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '''${classStudent.nameClass}''',
                    style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                _buildButton(context, 'Sửa', editClassStudent,
                    color: AppColor.colorGreen),
                SizedBox(width: 5.0),
                _buildButton(context, 'Xoá', deleteClassStudent,
                    color: AppColor.colorRed),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              'Sĩ số lớp: ${classStudent.studentNumber}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'Thành tích: ${classStudent.achievements}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'Lớp Trưởng: ${classStudent.classMonitor}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, void Function()? onPressed,
      {Color color = AppColor.colorGreen}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: 0.0,
      ),
      child: Text(label),
    );
  }

  void editClassStudent() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                EditClassStudentScreen(classStudent: classStudent)));
  }

  void deleteClassStudent() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Xoá', 'Bạn chắc chắn muốn xoá lớp học này?');
      },
    ).then((acceptDelete) {
      if (acceptDelete ?? false) {
        HomeBloC.getInstance()
            .deleteClassStudent(classStudent)
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringUtil.stringFromException(error))));
        });
        if (widget.onRemoved != null) {
          widget.onRemoved!.call();
        }
      }
    });
  }
}
