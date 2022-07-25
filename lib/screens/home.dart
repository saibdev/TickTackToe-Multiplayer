import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/settings_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: orientation == Orientation.portrait? const EdgeInsets.all(30) : const EdgeInsets.symmetric(horizontal: 150),
                    child: Center(
                      child: GetBuilder<SettingsController>(
                        init: SettingsController(),
                        builder: (settingsController) {
                          return Image.asset(
                            'assets/themes/${settingsController.theme.toLowerCase()}/homeStyle.png',
                            width: Get.width/1.5,
                          );
                        }
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Choose your playing mode',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flex(
                    direction: orientation == Orientation.portrait? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: orientation == Orientation.portrait? 7.5 : 0),
                        child: SizedBox(
                          width: Get.width / 3,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed('/game_settings');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 102, 255),
                              primary: Colors.white,
                              elevation: 7,
                              shape: const StadiumBorder(),
                              shadowColor: Colors.blue.shade200
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('With AI'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: orientation == Orientation.portrait? 7.5 : 0),
                        child: SizedBox(
                          width: Get.width / 3,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed('/multiplayer_options');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              primary: Colors.blueGrey,
                              elevation: 7,
                              shape: const StadiumBorder(),
                              shadowColor: Colors.blue.shade200
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('With a friend'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/settings');
                    },
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 7,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.blue.shade100,
                    ),
                    child: Image.asset(
                      'assets/icons/settings.png',
                      width: 20,
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}