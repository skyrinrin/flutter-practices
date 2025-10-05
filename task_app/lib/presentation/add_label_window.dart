import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/common/common.dart';
import 'package:task_app/provider/provider.dart';

class AddLabelWindow extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddLabelWindow> createState() => _AddLabelWindowState();
}

class _AddLabelWindowState extends ConsumerState<AddLabelWindow> {
  Color _selectedColor = Colors.black;
  TextEditingController _controller = TextEditingController();

  // 追加ボタン押下
  void _pushedAddButton(Application app) async {
    final labelsNames = ref.read(labelsNameProvider);
    if (_controller.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(Common.warningSnackBar);
    } else {
      await app.addLabel(_controller.text, _selectedColor);
      if (labelsNames.contains(_controller.text)) {
        ScaffoldMessenger.of(context).showSnackBar(_warningSnackBar);
      }
    }
    Navigator.pop(context);
  }

  final _warningSnackBar = SnackBar(
    content: Text(
      '既に同じ名前のラベルが存在します',
      style: TextStyle(fontSize: 20),
      selectionColor: Color.fromARGB(0, 218, 50, 50),
    ),
  );

  // カラーピッカー
  Widget _colorPicker() {
    return BlockPicker(
      pickerColor: _selectedColor,
      onColorChanged: (Color color) {
        setState(() {
          _selectedColor = color;
        });
      },
    );
  }

  // カラー選択ダイアログ
  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('色を選択してください'),
          content: SingleChildScrollView(child: _colorPicker()),
        );
      },
    );
  }

  // ラベルタイトル入力ウィジェット
  Widget _inputLabelTitle() {
    return Container(
      height: 100,
      width: 205,
      child: Stack(
        children: [
          Text('ラベルを追加', style: TextStyle(fontSize: 20)),
          Positioned(
            top: 42,
            child: Container(
              height: 40,
              width: 205,

              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'ラベル名',
                  filled: true,
                  fillColor: Color(0xFFebebeb),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // カラー選択ウィジェット
  Widget _selectColorWidget() {
    return Container(
      height: 80,

      child: Stack(
        children: [
          Text('カラー選択', style: TextStyle(fontSize: 16)),
          Positioned(
            top: 27,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.palette),
                  onPressed: () => _showColorPickerDialog(),
                ),
                GestureDetector(
                  onTap: () => _showColorPickerDialog(),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 追加ボタン
  Widget _addButtonWidget(Application app) {
    return GestureDetector(
      onTap: () => _pushedAddButton(app),
      child: Container(
        height: 35,
        width: 75,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text("追加", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Application app = ref.read(applicationProvider);
    return Container(
      height: 340,
      width: double.infinity,
      // width: 300,
      child: Stack(
        children: [
          Positioned(top: 36, left: 28, child: _inputLabelTitle()),
          Positioned(top: 140, left: 28, child: _selectColorWidget()),
          Positioned(top: 28, right: 24, child: _addButtonWidget(app)),
        ],
      ),
    );
  }
}
