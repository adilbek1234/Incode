import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// цвета
const Color primaryColor = Color(0xFFFFB74D); 
const Color textColor = Color(0xFF424242); 
const Color backgroundColor = Color(0xFFFAFAFA); 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // ВНИМАНИЕ: Замените 'http://localhost:5000/auth/register' на реальный URL
    // для работы на физическом устройстве или в эмуляторе.
    final response = await http.post(
      Uri.parse('http://localhost:5000/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация успешна!')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Ошибка регистрации'),
          backgroundColor: Colors.redAccent, // Визуальный акцент на ошибке
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Создайте свой Светлый Путь',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            // Карточка для формы, идентичная LoginPage
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
                    Icons.person_add_alt_1_outlined, // Иконка для регистрации
                    size: 64,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Text(
                    'Начните свой путь к инклюзивному обучению.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Поле ввода Имени
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: textColor),
                    decoration: _getInputDecoration(
                      labelText: 'Имя',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Введите ваше имя' : null,
                  ),
                  const SizedBox(height: 15),

                  // Поле ввода Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: textColor),
                    decoration: _getInputDecoration(
                      labelText: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) => !value!.contains('@')
                        ? 'Введите корректный email'
                        : null,
                  ),
                  const SizedBox(height: 15),

                  // Поле ввода Пароля
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: textColor),
                    decoration: _getInputDecoration(
                      labelText: 'Пароль (мин. 6 символов)',
                      icon: Icons.lock_outline,
                    ),
                    validator: (value) => value!.length < 6
                        ? 'Минимум 6 символов'
                        : null,
                  ),
                  const SizedBox(height: 30),

                  // Кнопка Регистрации (Акцентный цвет)
                  _loading
                      ? const CircularProgressIndicator(color: primaryColor)
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                  
                  const SizedBox(height: 10),

                  // Кнопка Входа
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      'Уже есть аккаунт? Войти',
                      style: TextStyle(color: textColor, decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Вспомогательная функция для генерации одинакового стиля полей ввода
  InputDecoration _getInputDecoration({required String labelText, required IconData icon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      prefixIcon: Icon(icon, color: primaryColor),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }
}