import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Определяем цвета из дизайн-концепции для удобства
const Color primaryColor = Color(0xFFFFB74D); // Мягкий Оранжевый (Янтарный)
const Color textColor = Color(0xFF424242); // Темно-Серый
const Color backgroundColor = Color(0xFFFAFAFA); // Светло-Серый фон

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // ВНИМАНИЕ: Замените 'http://localhost:5000/auth/login' на реальный URL
    // для работы на физическом устройстве или в эмуляторе.
    final response = await http.post(
      Uri.parse('http://localhost:5000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вход выполнен успешно!')),
      );
      Navigator.pushReplacementNamed(context, '/courses');
    } else {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Ошибка входа'),
          backgroundColor: Colors.redAccent, // Визуальный акцент на ошибке
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Фон становится светло-серым
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'InCode', // Название проекта
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // Светлая AppBar
        elevation: 1, // Легкая тень
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            // Карточка для формы
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school_outlined, // Иконка, символизирующая обучение
                    size: 64,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'С возвращением!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Text(
                    'Пожалуйста, введите свои данные для продолжения.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Поле ввода Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'qwerty@mail.com',
                      labelStyle: const TextStyle(color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    validator: (value) =>
                        !value!.contains('@') ? 'Введите корректный email' : null,
                  ),
                  const SizedBox(height: 15),

                  // Поле ввода Пароля
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      hintText: '123456',
                      labelStyle: const TextStyle(color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? 'Минимум 6 символов' : null,
                  ),
                  const SizedBox(height: 30),

                  // Кнопка Входа (Акцентный цвет)
                  _loading
                      ? const CircularProgressIndicator(color: primaryColor)
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4, // Добавляем тень
                          ),
                          child: const Text(
                            'Войти',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                  
                  const SizedBox(height: 10),

                  // Кнопка Регистрации
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Нет аккаунта? Зарегистрироваться',
                      style: TextStyle(color: textColor, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}