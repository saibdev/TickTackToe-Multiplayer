import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GetBuilder<SettingsController>(
            init: SettingsController(),
            builder: (controller) {
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Settings', 
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: controller.nickName,),
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
                      ),
                      onSubmitted: (newName) {
                        controller.setNickname(newName);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        'Theme',
                        style: Get.textTheme.titleSmall,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'Default',
                          groupValue: controller.theme,
                          onChanged: (n) {
                            controller.setTheme('Default');
                          }
                        ),
                        const Text('Default'),
                        Radio(
                          value: 'Colorful',
                          groupValue: controller.theme,
                          onChanged: (n) {
                            controller.setTheme('Colorful');
                          }
                        ),
                        const Text('Colorful'),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}