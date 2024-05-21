import 'package:flutter/material.dart';

class EditThemeDialog extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final int initialFear;
  final int initialDifficulty;
  final void Function(String, String, int, int) onSave;

  const EditThemeDialog({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialFear,
    required this.initialDifficulty,
    required this.onSave,
  });

  @override
  State<EditThemeDialog> createState() => _EditThemeDialogState();
}

class _EditThemeDialogState extends State<EditThemeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fearController = TextEditingController();
  final _difficultyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle;
    _descriptionController.text = widget.initialDescription;
    _fearController.text = widget.initialFear.toString();
    _difficultyController.text = widget.initialDifficulty.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fearController.dispose();
    _difficultyController.dispose();
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
                  // Fear input field
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
                  // Difficulty input field
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final fear = int.parse(_fearController.text);
                    final difficulty = int.parse(_difficultyController.text);
                    widget.onSave(title, description, fear, difficulty);
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
