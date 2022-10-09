import 'dart:developer';
import 'package:dio/dio.dart';

import '../models/endereco_model.dart';

abstract class EnderecoRepository {
  Future<EnderecoModel> getCep(String cep);
}

class EnderecoRepositoryImpl implements EnderecoRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json');
      return EnderecoModel.fromMap(result.data);
    } on DioError catch (e) {
      log('Erro ao buscar CEP', error: e);
      throw Exception('Erro ao buscar o CEP');
    }
  }
}
