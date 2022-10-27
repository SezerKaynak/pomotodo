import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class EditTask extends StatefulWidget {
  const EditTask({
    super.key,
    required this.taskName,
    required this.taskType,
    required this.taskInfo,
    required this.isDone,
    required this.isArchive,
    required this.id,

    //required this.isActive,
  });
  final String taskName;
  final String taskType;
  final String taskInfo;
  final bool isDone;
  final bool isArchive;
  final String id;
  //final bool isActive;
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  bool isCheckedDone = false;
  bool isCheckedArchive = false;
  @override
  Widget build(BuildContext context) {
    var title = "Görev Düzenleme Sayfası";
    var subtitle = "Görevin ismi,türü ve açıklamasını düzenleyebilirsiniz👋";
    var taskN = "Görev İsmi";
    var taskT = "Görev Türü";
    var taskI = "Görev Açıklaması";

    final TextEditingController _taskNameController = TextEditingController();
    final TextEditingController _taskTypeController = TextEditingController();
    final TextEditingController _taskInfoController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: ScreenPadding()
                .screenPadding
                .copyWith(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                ScreenTexts(
                  title: title,
                  theme: Theme.of(context).textTheme.headline4,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left,
                ),
                ScreenTexts(
                    title: subtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: taskN,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskNameController.text = widget.taskName,
                    obscure: false,
                    controller: _taskNameController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskT,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskTypeController.text = widget.taskType,
                    obscure: false,
                    controller: _taskTypeController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskI,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskInfoController.text = widget.taskInfo,
                    obscure: false,
                    controller: _taskInfoController,
                    height: 120,
                    maxLines: 3),
                FormField(
                  initialValue: widget.isDone,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Görev tamamlandı mı?'),
                          activeColor: Colors.blue,
                          value: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                              isCheckedDone = state.value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.platform,
                        ),
                      ],
                    );
                  },
                ),
                FormField(
                  initialValue: widget.isArchive,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Görev arşivlensin mi?'),
                          activeColor: Colors.blue,
                          value: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                              isCheckedArchive = state.value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.platform,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          CollectionReference users = FirebaseFirestore.instance
                              .collection(
                                  'Users/${context.read<PomotodoUser>().userId}/tasks');
                          var task = users.doc(widget.id);
                          task.set({
                            'taskNameCaseInsensitive':
                                _taskNameController.text.toLowerCase(),
                            'taskName': _taskNameController.text,
                            'taskType': _taskTypeController.text,
                            'taskInfo': _taskInfoController.text,
                            "isDone": isCheckedDone,
                            "isActive": true,
                            "isArchive": isCheckedArchive
                          });
                          isCheckedDone && isCheckedArchive
                              ? SmartDialog.showToast("Görev arşive taşındı!")
                              : isCheckedDone
                                  ? SmartDialog.showToast(
                                      "Görev tamamlanmış görevler sayfasına taşındı!")
                                  : isCheckedArchive
                                      ? SmartDialog.showToast(
                                          "Görev arşive taşındı!")
                                      : DoNothingAction();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskView()),
                              ModalRoute.withName("/Task"));
                        },
                        child: const Text("Güncelle"))),
              ],
            ),
          ),
        ));
  }
}
