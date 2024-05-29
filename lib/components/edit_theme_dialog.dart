import 'package:flutter/material.dart';

class EditThemeDialog extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final int initialFear;
  final int initialDifficulty;
  final List<String> initialTimetable;
  final void Function(String, String, int, int, List<String>) onSave;

  const EditThemeDialog({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialFear,
    required this.initialDifficulty,
    required this.initialTimetable,
    required this.onSave,
  });

  @override
  State<EditThemeDialog> createState() => _EditThemeDialogState();
}

class _EditThemeDialogState extends State<EditThemeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _fearController;
  late TextEditingController _difficultyController;
  late List<TextEditingController> _timetableControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
    _fearController =
        TextEditingController(text: widget.initialFear.toString());
    _difficultyController =
        TextEditingController(text: widget.initialDifficulty.toString());
    _timetableControllers = widget.initialTimetable
        .map((timetable) => TextEditingController(text: timetable))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fearController.dispose();
    _difficultyController.dispose();
    for (var controller in _timetableControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('테마 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '설명'),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _fearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '공포도'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '공포도를 입력해주세요.';
                        }
                        try {
                          int.parse(value);
                          return null;
                        } on FormatException {
                          return '공포도는 숫자만 입력할 수 있습니다.';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _difficultyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '난이도'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '난이도를 입력해주세요.';
                        }
                        try {
                          int.parse(value);
                          return null;
                        } on FormatException {
                          return '난이도는 숫자만 입력할 수 있습니다.';
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('시간표'),
              const SizedBox(height: 8),
              Column(
                children: List.generate(_timetableControllers.length, (index) {
                  final controller = _timetableControllers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(labelText: '시간'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '시간을 입력해주세요.';
                              }
                              RegExp timeFormatRegExp =
                                  RegExp(r'^[0-9]{2}:[0-9]{2}$');
                              if (!timeFormatRegExp.hasMatch(value)) {
                                return '시간 형식이 올바르지 않습니다. (HH:MM)';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _timetableControllers.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.delete),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _timetableControllers.insert(
                                  index + 1, TextEditingController());
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final fear = int.parse(_fearController.text);
                    final difficulty = int.parse(_difficultyController.text);
                    final timetable = _timetableControllers
                        .map((controller) => controller.text)
                        .toList();
                    widget.onSave(
                        title, description, fear, difficulty, timetable);
                    Navigator.pop(context);
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
