//Importar todas as bibliotecas e dependencias para 

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './page_main.dart';
import '../repositories/repository.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _pageController = PageController();
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _requesting = false;

  Future _requestRegister() async {
    setState(() {
      _requesting = true;
    });
    http.Response response = await Repository.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (mounted) {
      setState(() {
        _requesting = false;
      });
      if (response.statusCode < 400) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
        final snackBar = SnackBar(
          content: const Text(
            'Cadastro realizado com sucesso!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade700,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text(
            'Erro ao cadastrar usuário.',
            style: TextStyle(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future _requestLogin() async {
    setState(() {
      _requesting = true;
    });
    final response =
        await Repository.login(_emailController.text, _passwordController.text);
    if (mounted) {
      setState(() {
        _requesting = false;
      });
      if (response.statusCode < 400) {
        _passwordController.text = '';
        final jsonResponse = jsonDecode(response.body);
        final accessToken = jsonResponse['access_token'];
        final userId = jsonResponse['userId'];
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PageMain(
              authorization: accessToken,
              userId: userId,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        const snackBar = SnackBar(
          content: Text(
            'Credenciais inválidas.',
            style: TextStyle(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'imagens/Login.png'), 
                fit: BoxFit
                    .cover, // Para a imagem cobrir todo o container
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY:
                    5.0), // Sigma para aumentar ou diminuir o desfoque
            child: Container(
              color: Colors.black.withOpacity(
                  0.0), // Ajusta a opacidade para criar efeitos diferentes
            ),
          ),
          PageView(
            controller: _pageController,
            children: [
              Center(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 300,
                      child: Form(
                        key:
                            _formKeyLogin, // Adicionando a chave do formulário aqui 
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Bem-vindo (a)',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 33, 205, 243),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !_requesting,
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira um email';
                                  } else if (!value.contains('@')) {
                                    return 'Por favor, insira um email válido';
                                  }
                                  return null; 
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !_requesting,
                                controller: _passwordController,
                                decoration:
                                    const InputDecoration(labelText: 'Senha'),
                                obscureText: true, // Mantém a senha obscurecida naquele padrão de segurança
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha';
                                  } else if (value.length < 6) {
                                    return 'A senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null; 
                                },
                                onFieldSubmitted: (value) {
                                  _requestLogin();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: _requesting
                                      ? null
                                      : () {
                                          if (_formKeyLogin.currentState!
                                              .validate()) {
                                            _requestLogin();
                                          }
                                        },
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(double.maxFinite, 40),
                                    ),
                                  ),
                                  child: _requesting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Entrar'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 300,
                      child: Form(
                        key:
                            _formKeyRegister, // Adicionando a chave de formulario
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: _requesting
                                  ? null
                                  : () {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.fastOutSlowIn,
                                      );
                                    },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'Voltar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !_requesting,
                                controller: _nameController,
                                decoration: const InputDecoration(
                                    labelText: 'Nome completo'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu nome completo';
                                  } else if (value.split(' ').length < 2) {
                                    return 'Pelo menos nome e sobrenome';
                                  }
                                  return null; 
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !_requesting,
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira um email';
                                  } else if (!value.contains('@')) {
                                    return 'Por favor, insira um email válido';
                                  }
                                  return null; 
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !_requesting,
                                controller: _passwordController,
                                decoration:
                                    const InputDecoration(labelText: 'Senha'),
                                obscureText: true, // Para respeitar o padrão de senha obscurecida
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira sua senha';
                                  } else if (value.length < 6) {
                                    return 'A senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null; 
                                },
                                onFieldSubmitted: (value) {
                                  _requestRegister();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: _requesting
                                      ? null
                                      : () {
                                          if (_formKeyRegister.currentState!
                                              .validate()) {
                                            _requestRegister();
                                          }
                                        },
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(double.maxFinite, 40),
                                    ),
                                  ),
                                  child: _requesting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Cadastrar'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
