import 'dart:ui';

class Label {
  final int id; //IDを数字管理すると穴があいたときに困るかも(要注意)
  final String name;
  final String color;
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
    'color': color,
    'isExpanded': 'false',
  };

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    name: json['name'],
    id: json['id'],
    color: json['color'],
    isExpanded: json['isExpanded'],
  );
}
