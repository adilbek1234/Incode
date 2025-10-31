import 'package:flutter/material.dart';
import 'api_service.dart';

// Определяем цвета из дизайн-концепции
const Color primaryColor = Color(0xFFFFB74D); // Мягкий Оранжевый (Янтарный)
const Color secondaryColor = Color(0xFF66BB6A); // Светлый Зеленый (для фона/статуса)
const Color textColor = Color(0xFF424242); // Темно-Серый
const Color backgroundColor = Color(0xFFFAFAFA); // Светло-Серый фон

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<dynamic>> courses;
  int _selectedIndex = 1; // Устанавливаем "Курсы" как активный пункт

  @override
  void initState() {
    super.initState();
    courses = ApiService.getCourses();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: Navigator.pushNamed(context, '/home'); break;
      case 1: break; // Курсы (текущая страница)
      case 2: Navigator.pushNamed(context, '/profile'); break;
      case 3: Navigator.pushNamed(context, '/login'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Каталог Курсов",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: textColor),
        // Кнопка для поиска/фильтрации
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: primaryColor),
            onPressed: () {
              // Логика фильтрации
            },
          ),
        ],
      ),

      // Обновленный BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor, // Активный элемент - Янтарный
        unselectedItemColor: Colors.grey.shade600, // Неактивный элемент - Серый
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Используем fixed для единообразия
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Главное"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Курсы"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Профиль"),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: "Выйти"),
        ],
      ),

      // Тело страницы для отображения курсов
      body: FutureBuilder<List<dynamic>>(
        future: courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.signal_wifi_off, size: 40, color: Colors.redAccent),
                    const SizedBox(height: 10),
                    Text(
                      "Ошибка загрузки данных: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Курсы не найдены 😥",
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final course = data[index];
              return _CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}

// Отдельный виджет для стильной карточки курса
class _CourseCard extends StatelessWidget {
  final dynamic course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    // Проверка, есть ли изображение, и использование заглушки, если нет
    final imageUrl = course["image"] ?? 'https://via.placeholder.com/600x400.png?text=Course+Image';
    final String category = course["category"] ?? "Общее";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4, // Красивая тень
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Закругленные края
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/course',
            arguments: course,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение с закругленными верхними углами
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                // Добавляем обработку ошибок загрузки изображения
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Категория (маленький тег)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Заголовок курса
                  Text(
                    course["title"] ?? "Название курса",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Описание курса
                  Text(
                    course["description"] ?? "Краткое описание курса отсутствует.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Кнопка или индикатор прогресса (можно добавить)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Подробнее ->',
                        style: TextStyle(
                          color: secondaryColor.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}