import 'package:flutter/material.dart';

// Определяем цвета из дизайн-концепции для единообразия
const Color primaryColor = Color(0xFFFFB74D); // Мягкий Оранжевый (Янтарный)
const Color secondaryColor = Color(0xFF66BB6A); // Светлый Зеленый (для тегов)
const Color textColor = Color(0xFF424242); // Темно-Серый
const Color backgroundColor = Color(0xFFFAFAFA); // Светло-Серый фон

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получение аргументов курса
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final course = args ?? {};

    final image = course["image"] as String?;
    final title = course["title"] as String? ?? 'Курс без названия';
    final description = course["description"] as String? ?? 'Подробное описание курса отсутствует.';
    final category = course["category"] as String? ?? '';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Изображение курса
            _buildCourseImage(image),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Тег Категории
                  if (category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // 3. Заголовок
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const Divider(height: 30, color: Colors.grey),

                  // 4. Описание
                  const Text(
                    'О курсе:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 5. Кнопка действия (в самом низу)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill, size: 24),
                      label: const Text(
                        'Начать курс',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        // Здесь будет логика для перехода к первому уроку
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Начинаем обучение!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный виджет для отображения изображения с закругленными углами
  Widget _buildCourseImage(String? image) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: image != null && image.isNotEmpty
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                );
              },
            )
          : const Center(
              child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
            ),
    );
  }
}