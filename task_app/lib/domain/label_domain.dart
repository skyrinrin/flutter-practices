import 'dart:ffi';
import 'dart:ui';

class Label {
  final String id;
  final int order;
  final String name;
  final Color color;
  bool isExpanded;

  Label({
    required this.name,
    required this.id,
    required this.order,
    required this.color,
    required this.isExpanded,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'order': order,
    // 'color': '#${color.value.toRadixString(16).padLeft(6, '0') + '00'}',
    'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',

    'isExpanded': 'false',
  };

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    name: json['name'] as String,
    order: json['order'] as int,
    // order: json['order'] ?? 10,
    id: json['id'] as String,
    color: Color(
      int.parse(
        json['color'].toString().replaceFirst('#', ''),
        radix: 16,
      ), //ここはappかどっちかわからない
    ),
    isExpanded: json['isExpanded'] == 'true' ? true : false,
  );
}
