import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'features/chat/chat_controller.dart';
import 'features/chat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();

  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(apiClient: apiClient),
      child: Consumer<ChatController>(
        builder: (context, ctrl, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chatbot RAG',
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: ctrl.themeMode,
            home: const ChatScreen(),
          );
        },
      ),
    );
  }
}

