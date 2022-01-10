import 'package:final_exam/bloc/add_class_student_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddClassStudentScreen extends StatefulWidget {
  const AddClassStudentScreen({Key? key}) : super(key: key);

  @override
  _AddClassStudentScreenState createState() => _AddClassStudentScreenState();
}

class _AddClassStudentScreenState extends State<AddClassStudentScreen> {
  TextEditingController _nameClassController = TextEditingController();
  TextEditingController _studentNumberController = TextEditingController();
  TextEditingController _achievementsController = TextEditingController();
  TextEditingController _classMonitorController = TextEditingController();
  FocusNode _nameClassNode = FocusNode();
  FocusNode _studentNumberNode = FocusNode();
  FocusNode _achievementsNode = FocusNode();
  FocusNode _classMonitorNode = FocusNode();
  late AddClassStudentBloC _addClassStudentBloC;

  @override
  void initState() {
    _addClassStudentBloC = AddClassStudentBloC.getInstance();
    _addClassStudentBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _nameClassController.dispose();
    _studentNumberController.dispose();
    _achievementsController.dispose();
    _classMonitorController.dispose();
    _nameClassNode.dispose();
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
                          focusNode: _nameClassNode,
                          labelText: 'Tên lớp',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          onChanged: (value) =>
                              _addClassStudentBloC.nameClass = value,
                          onSubmitted: (value) {
                            _studentNumberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _studentNumberController,
                          focusNode: _studentNumberNode,
                          keyboardType: TextInputType.number,
                          labelText: 'Sĩ số Lớp',
                          maxLength: 10,
                          onChanged: (value) =>
                              _addClassStudentBloC.studentNumber = value,
                          onSubmitted: (value) {
                            _achievementsNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _achievementsController,
                          focusNode: _achievementsNode,
                          labelText: 'Thành tích',
                          textCapitalization: TextCapitalization.words,
                          maxLength: 50,
                          onChanged: (value) =>
                              _addClassStudentBloC.achievements = value,
                          onSubmitted: (value) {
                            _classMonitorNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _classMonitorController,
                          focusNode: _classMonitorNode,
                          labelText: 'Lớp Trưởng',
                          keyboardType: TextInputType.text,
                          onChanged: (value) =>
                              _addClassStudentBloC.classMonitor = value,
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
        'Thêm lớp học',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _addClassStudentBloC.saveButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: AppColor.colorGrey97,
              minWidth: double.infinity,
              height: 54,
              color: AppColor.colorDarkBlue,
              onPressed: isEnable ? addClassStudent : null,
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _addClassStudentBloC.loadingState,
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

  void addClassStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addClassStudentBloC.addClassStudent().then((sucess) {
      HomeBloC.getInstance().getListClassStudent();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm lớp học');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _addClassStudentBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
