import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  // Временно мок-данные (потом заменишь на запрос к MongoDB)
  final String userName = "Айдос К.";
  final String userEmail = "aidos@example.com";
  final String userRole = "Студент";
  final double progress = 0.65;

  const ProfilePage({super.key}); // 65%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Профиль",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Фото профиля
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.amber[600],
              child: Text(
                userName[0],
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              userName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              userEmail,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              userRole,
              style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),

            // Прогресс обучения
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Прогресс обучения",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  color: Colors.amber[600],
                  backgroundColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                ),
                const SizedBox(height: 5),
                Text("${(progress * 100).toStringAsFixed(0)}%"),
              ],
            ),
            const SizedBox(height: 30),

            // Кнопки
            _buildActionButton(
              icon: Icons.edit,
              label: "Редактировать профиль",
              onPressed: () {},
            ),
            _buildActionButton(
              icon: Icons.book,
              label: "Мои курсы",
              onPressed: () {},
            ),
            _buildActionButton(
              icon: Icons.settings,
              label: "Настройки",
              onPressed: () {},
            ),
            _buildActionButton(
              icon: Icons.logout,
              label: "Выйти",
              color: Colors.redAccent,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.amber[700]),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onPressed,
      ),
    );
  }
}
