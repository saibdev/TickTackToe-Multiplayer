import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/screens/create_room_screen.dart';
import 'package:tictactoe/screens/ai_game_settings.dart';
import 'package:tictactoe/screens/home.dart';
import 'package:tictactoe/screens/multiplayer_options.dart';
import 'package:tictactoe/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put<SettingsController>(SettingsController());

    return GetMaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/game_settings', page: () => const GameSettings()),
        GetPage(name: '/multiplayer_options', page: () => const MultiplayerOptions()),
        GetPage(name: '/create_room', page: () => const CreateRoomScreen()),
      ],
      initialRoute: '/',
    );
  }
}
