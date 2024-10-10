import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xogame/board_state.dart';
import 'package:xogame/login_screen.dart';
import 'package:xogame/player_model.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = "GameScreen";

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const String playerX = "X";
  static const String playerO = "O";

  List<String> boardState = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  int player1Score = 0;
  int player2Score = 0;
  int cnt = 0;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as playerModels;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 97, 79),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      arguments.playerOne,
                      style: GoogleFonts.coiny(
                        textStyle:
                        const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    Text(
                      "$player1Score",
                      style: GoogleFonts.coiny(
                        textStyle:
                        const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      arguments.playerTwo,
                      style: GoogleFonts.coiny(
                        textStyle:
                        const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    Text(
                      "$player2Score",
                      style: GoogleFonts.coiny(
                        textStyle:
                        const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 70),
            buildBoardRow(0, 1, 2),
            const SizedBox(height: 30),
            buildBoardRow(3, 4, 5),
            const SizedBox(height: 30),
            buildBoardRow(6, 7, 8),
            const SizedBox(height: 100),
            buildResetButton(),
          ],
        ),
      ),
    );
  }

  Row buildBoardRow(int firstIndex, int secondIndex, int thirdIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BoardState(boardState[firstIndex], onBtnClicked, firstIndex),
        BoardState(boardState[secondIndex], onBtnClicked, secondIndex),
        BoardState(boardState[thirdIndex], onBtnClicked, thirdIndex),
      ],
    );
  }

  Container buildResetButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextButton(
        onPressed: () {
          reset();
        },
        child: Text(
          "Reset",
          style: GoogleFonts.aladin(
            textStyle: const TextStyle(color: Colors.black, fontSize: 40),
          ),
        ),
      ),
    );
  }

  void onBtnClicked(int index) {
    if (boardState[index].isNotEmpty) return;

    setState(() {
      final currentSymbol = (cnt % 2 == 0) ? playerX : playerO;

      boardState[index] = currentSymbol;
      cnt++;

      if (checkWinner(currentSymbol)) {
        (currentSymbol == playerX) ? player1Score += 10 : player2Score += 10;
        showWinnerDialog(currentSymbol);
        return;
      }

      if (cnt == 9) {
        showDrawDialog();
        return;
      }
    });
  }

  bool checkWinner(String symbol) {
    for (int i = 0; i < 9; i += 3) {
      if (boardState[i] == symbol &&
          boardState[i + 1] == symbol &&
          boardState[i + 2] == symbol) {
        return true;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (boardState[i] == symbol &&
          boardState[i + 3] == symbol &&
          boardState[i + 6] == symbol) {
        return true;
      }
    }
    if (boardState[0] == symbol &&
        boardState[4] == symbol &&
        boardState[8] == symbol) {
      return true;
    }
    if (boardState[2] == symbol &&
        boardState[4] == symbol &&
        boardState[6] == symbol) {
      return true;
    }
    return false;
  }

  void showWinnerDialog(String symbol) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations $symbol, you Won!'),
          content: const Text('Choose what you want!'),
          actions: [
            TextButton(
              child: const Text('Play again'),
              onPressed: () {
                Navigator.of(context).pop();
                playAgain();
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.popAndPushNamed(context, LoginScreen.routeName);
                reset();
              },
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Draw!'),
          content: const Text('Choose what you want!'),
          actions: [
            TextButton(
              child: const Text('Play again'),
              onPressed: () {
                Navigator.of(context).pop();
                playAgain();
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.popAndPushNamed(context, LoginScreen.routeName);
                reset();
              },
            ),
          ],
        );
      },
    );
  }

  void reset() {
    boardState = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ];
    player1Score = 0;
    player2Score = 0;
    cnt = 0;
    setState(() {});
  }

  void playAgain() {
    boardState = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ];
    cnt = 0;
    setState(() {});
  }
}
