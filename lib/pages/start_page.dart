import 'package:flutter/material.dart';

import 'package:busca_cep/models/endereco_model.dart';
import 'package:busca_cep/repositories/endereco_repository.dart';
import 'package:flutter/services.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final EnderecoRepository enderecoRepository = EnderecoRepositoryImpl();
  final formKey = GlobalKey<FormState>();
  final cepEController = TextEditingController();

  EnderecoModel? enderecoModel;
  bool loading = false;

  @override
  void dispose() {
    cepEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Buscar CEP")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                controller: cepEController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? "CEP obrigatório" : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco =
                          await enderecoRepository.getCep(cepEController.text);
                      setState(() {
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        //para limpar a informação da tela quando ocorrer erro
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao buscar o CEP'),
                          backgroundColor: Color.fromARGB(179, 250, 54, 40),
                        ),
                      );
                    } finally {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                child: const Text("Buscar"),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              // USANDO UM IF TERNARIO
              enderecoModel != null
                  ? Text(
                      '${enderecoModel?.logradouro}\n${enderecoModel?.complemento}\n${enderecoModel?.cep}',
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              // USANDO UM WIDGET DE VISIBILIDADE, EVITA IF NO LAYOUT
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  '${enderecoModel?.logradouro}\n${enderecoModel?.complemento}\n${enderecoModel?.cep}',
                ),
              )
            ]),
          ),
        ));
  }
}
