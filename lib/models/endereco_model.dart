// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EnderecoModel {
  final String cep;
  final String logradouro;
  final String complemento;

  EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      complemento: map['complemento'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String source) =>
      EnderecoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
