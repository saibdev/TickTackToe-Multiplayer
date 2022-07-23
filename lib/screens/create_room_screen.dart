
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/controllers/online_game_controller.dart';
import 'package:tictactoe/controllers/settings_controller.dart';
import 'package:tictactoe/models/tic_tac_toe.dart';
import 'package:tictactoe/screens/online_game.dart';
import 'package:tictactoe/widgets/letter_choices.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  GameLetter letter = GameLetter.none;
  late final RoomProvider serverConnection;
  String? roomId;
  bool fetchingRoomId = false;

  @override
  void initState() {
    super.initState();

    serverConnection = RoomProvider(
      onUserJoin: (uInfo) {
        showTopSnackBar(
            context,
            const CustomSnackBar.success(
              message:
                  "A friend has joined the room!",
            ),
        );
        Get.off(() => OnlineGame(userInfo: uInfo, roomServerProvider: serverConnection,));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (roomId != null)
            Center(
              child: Text(
                "Room ID: ${roomId == null? '000000': roomId!}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Pick your side",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LetterChoices(
                showSelectedOnly: true,
                onChange: (value) {
                  setState(() {
                    letter = value;
                  });
                }
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  if (fetchingRoomId == true || roomId == null)
                  SizedBox(
                    width: Get.width/2.5,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          fetchingRoomId = true;
                        });
                        serverConnection.getRoomId(letter, Get.put(SettingsController()).nickName).then((value) {
                          setState(() {
                            roomId = value;
                            fetchingRoomId = false;
                          });
                        });
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
                        child: Text('Continue'),
                      ),
                    ),
                  ),
                  if (roomId != null)
                  const Text(
                    "Waiting for opponent to join ...",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}