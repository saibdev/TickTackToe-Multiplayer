import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tictactoe/controllers/online_game_controller.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/screens/local_multiplayer_settings.dart';
import 'package:tictactoe/screens/online_game.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MultiplayerOptions extends StatefulWidget {
  const MultiplayerOptions({Key? key}) : super(key: key);

  @override
  State<MultiplayerOptions> createState() => _MultiplayerOptionsState();
}

class _MultiplayerOptionsState extends State<MultiplayerOptions> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  bool showOnlineOptions = false;
  RoomProvider serverConnection = RoomProvider();
  bool joinRoom = false;
  TextEditingController roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    animation = CurvedAnimation(curve: Curves.easeInOutCubicEmphasized, parent: controller) //_tween.animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
  }

  //

  @override
  Widget build(BuildContext context) {
    if (showOnlineOptions == true) {
      controller.forward();
      //showOnlineOptions = false;
    } else {
      controller.reverse();
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: showOnlineOptions == true? 0 : 1,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.45,
                    child: TextButton(
                      onPressed: showOnlineOptions == true? () {
                        setState(() {
                          showOnlineOptions = false;
                        });
                      } : () {
                        Get.to(
                          () => const LocalMultiplayerSettings(),
                          opaque: false,
                          fullscreenDialog: true,
                        );
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
                        child: Text('Local'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Transform.translate(
                  offset: showOnlineOptions == false? const Offset(0, 0): Offset(0, - (64*animation.value)),
                  child: FractionallySizedBox(
                    widthFactor: 0.45,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          showOnlineOptions = true;
                        });
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
                        child: Text('Online'),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: showOnlineOptions == true? 250 : 100),
                opacity: showOnlineOptions == true? 1 : 0,
                child: Column(
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: joinRoom == false? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: FractionallySizedBox(
                            widthFactor: 0.45,
                            child: TextButton(
                              onPressed: showOnlineOptions == false? null : () {
                                debugPrint("Join Room");
                                setState(() {
                                  joinRoom = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 233, 196, 48),
                                primary: Colors.white,
                                elevation: 7,
                                shape: const StadiumBorder(),
                                shadowColor: Colors.orange.shade200
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Join Room'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondChild: Column(
                        children: [
                          TextField(
                            controller: roomIdController,
                            decoration: const InputDecoration(
                              labelText: 'Room ID',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                roomIdController.text = value.replaceAll(RegExp(r'[^0-9]'),'');
                                roomIdController.selection = TextSelection.fromPosition(TextPosition(offset: roomIdController.text.length));
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      joinRoom = false;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    shape: const CircleBorder(),
                                    elevation: 4,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.blue.shade100,
                                  ),
                                  child: const Icon(Ionicons.arrow_back_outline),
                                ),
                                if (roomIdController.value.text.length == 6)
                                TextButton(
                                  onPressed: () {
                                    serverConnection.joinRoom(roomIdController.value.text, Get.put(SettingsController()).nickName).then((value) {
                                      debugPrint(value.player1Nickname);
                                      showTopSnackBar(
                                          context,
                                          const CustomSnackBar.success(
                                            message:
                                                "You have joined the room successfully!",
                                          ),
                                      );
                                      Get.to(() => OnlineGame(userInfo: value, roomServerProvider: serverConnection,));
                                    }).catchError((err) {
                                      debugPrint(err);
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                            message:
                                                err.toString().replaceAll('Exception: ', ''),
                                          ),
                                      );
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    shape: const CircleBorder(),
                                    elevation: 4,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.blue.shade100,
                                  ),
                                  child: const Icon(Ionicons.arrow_forward_outline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (!joinRoom)
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.45,
                        child: TextButton(
                          onPressed: showOnlineOptions == false? null : () {
                            debugPrint("Create Room");
                            Get.toNamed('/create_room');
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
                            child: Text('Create Room'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}