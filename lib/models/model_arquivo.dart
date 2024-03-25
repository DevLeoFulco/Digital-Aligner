
import 'dart:convert';

//Definindo uma classe que representaria um arquivo normal
class Arquivo {
  String? type;
  List<int>? data;
  Arquivo({ //Meu construtor
    this.type,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'data': data,
    };
  }

  factory Arquivo.fromMap(Map<String, dynamic> map) {
    return Arquivo(
      type: map['type'] as String?,
      data: map['data'] != null
          ? (map['data'] as List)
              .map((item) => int.parse(item.toString()))
              .toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Arquivo.fromJson(String source) =>
      Arquivo.fromMap(json.decode(source) as Map<String, dynamic>);
}
