import 'package:final_exam/bloc/edit_class_student_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/class_student.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EditClassStudentScreen extends StatefulWidget {
  final ClassStudent classStudent;
  const EditClassStudentScreen({Key? key, required this.classStudent}) : super(key: key);

  @override
  _EditClassStudentScreenState createState() => _EditClassStudentScreenState();
}

class _EditClassStudentScreenState extends State<EditClassStudentScreen> {
  TextEditingController _nameClassController = TextEditingController();
  TextEditingController _studentNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  FocusNode _studentNumberNode = FocusNode();
  FocusNode _achievementsNode = FocusNode();
  FocusNode _classMonitorNode = FocusNode();
  EditClassStudentBloC _editBloC = EditClassStudentBloC.getInstance();
  late ClassStudent classStudent;

  @override
  void initState() {
    _editBloC.clearData();
    _editBloC.classStudent = widget.classStudent;
    classStudent = widget.classStudent;
    _nameClassController.text =
        '${classStudent.nameClass}';
    _studentNumberController.text = '${classStudent.studentNumber}';
    _addressController.text = '${classStudent.achievements}';
    _regionController.text = '${classStudent.classMonitor}';
    super.initState();
  }

  @override
  void dispose() {
    _nameClassController.dispose();
    _studentNumberController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _studentNumberNode.dispose();
    _achievementsNode.dispose();
    _classMonitorNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textField(
                          context,
                          controller: _nameClassController,
                          labelText: 'Tên Lớp',
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.nameClass =value,
                          onSubmitted: (value) {
                            _studentNumberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _studentNumberController,
                          focusNode: _studentNumberNode,
                          labelText: 'Sĩ số lớp',
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onChanged: (value) => _editBloC.studentNumber =value,
                          onSubmitted: (value) {
                            _achievementsNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _addressController,
                          focusNode: _achievementsNode,
                          labelText: 'Thành tích',
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.achievements = value,
                          onSubmitted: (value) {
                            _classMonitorNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _regionController,
                          focusNode: _classMonitorNode,
                          labelText: 'Lớp trưởng',
                          keyboardType: TextInputType.text,
                          onChanged: (value) => _editBloC.classMonitor = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 18.0),
                      ],
                    ),
                  ),
                ),
                _saveButton(context),
              ],
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Thông tin lớp học',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: AppColor.colorGrey97,
        minWidth: double.infinity,
        height: 54,
        color: AppColor.colorDarkBlue,
        onPressed: updateClassStudent,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: AppColor.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _editBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.colorGrey97.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  void updateClassStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _editBloC.updateClassStudent().then((success) {
      HomeBloC.getInstance().getListClassStudent();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
