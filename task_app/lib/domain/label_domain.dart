import 'dart:ui';

class Label {
  final int id; //IDを数字管理すると穴があいたときに困るかも(要注意)
  final String name;
  final Color color;
  bool isExpanded;

  Label({
    required this.name,
    required this.id,
    required this.color,
    required this.isExpanded,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    // 'color': '#${color.value.toRadixString(16).padLeft(6, '0') + '00'}',
    'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
    'isExpanded': 'false',
  };

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    name: json['name'],
    id: json['id'],
    color: Color(
      int.parse(json['color'].toString().replaceFirst('#', ''), radix: 16),
    ),
    isExpanded: json['isExpanded'],
  );
}
