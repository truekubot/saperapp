import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SaperApp extends StatefulWidget {
  const SaperApp({Key? key}) : super(key: key);

  @override
  State<SaperApp> createState() => _SaperAppState();
}

class _SaperAppState extends State<SaperApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 157, 178, 191),
        appBar: AppBar(
          title: const Text('saperApp'),
          backgroundColor: const Color.fromARGB(255, 39, 55, 77),
        ),
        body: Center(
          child: Builder(
            builder: (context) => AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                  ),
                  itemBuilder: (context, index) =>
                      _buildGridItems(context, index),
                  itemCount: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildGridItems(BuildContext context, int index) {
  int gridStateLength = 10;
  int x, y = 0;
  x = (index / gridStateLength).floor();
  y = (index % gridStateLength);
  return GridTile(child: ButtonWidget(x, y));
}

class ButtonWidget extends StatefulWidget {
  final int x;
  final int y;

  const ButtonWidget(
    this.x,
    this.y, {
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState(x, y);
}

class _ButtonWidgetState extends State<ButtonWidget> {
  String startText = "";
  final int x;
  final int y;

  _ButtonWidgetState(this.x, this.y);

  @override
  void initState() {
    super.initState();
    startText = '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 82, 109, 130)),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        ),
        onPressed: () {
          setState(() {
            startText = returnTextFromSquare(board[x][y]);
            board[x][y].wasDisplayed = true;
            if (board[x][y].hasBomb == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: false,
                    title: const Text('Przegrałeś!'),
                    content: const Padding(padding: EdgeInsets.all(8.0)),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          board = _createBoard();
                          Phoenix.rebirth(context);
                        },
                        child: const Text('Zagraj Ponownie'),
                      ),
                    ],
                  );
                },
              );
            } else {
              int test = 0;
              for (int i = 0; i < 10; i++) {
                for (int j = 0; j < 10; j++) {
                  if (board[i][j].wasDisplayed && !board[i][j].hasBomb) {
                    test++;
                  }
                  if (test == 85) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: false,
                          title: const Text('Wygrałeś!'),
                          content: const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                board = _createBoard();
                                Phoenix.rebirth(context);
                              },
                              child: const Text('Zagraj Ponownie'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              }
            }
          });
        },
        child: Text(
          startText,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

String returnTextFromSquare(Square square) {
  if (square.hasBomb) {
    return "X";
  } else {
    return square.bombsAround.toString();
  }
}

List<List<Square>> board = _createBoard();

void main() {
  runApp(Phoenix(child: const SaperApp()));
}

class Square {
  bool hasBomb;
  int bombsAround;
  bool wasDisplayed;

  Square({
    this.hasBomb = false,
    this.bombsAround = 0,
    this.wasDisplayed = false,
  });
}

List<List<Square>> _createBoard() {
  int row = 10;
  int col = 10;
  int bombCount = 15;

  List<List<Square>> board = List.generate(row, (i) {
    return List.generate(col, (j) {
      return Square();
    });
  });

  Random rand = Random(DateTime.now().millisecondsSinceEpoch);
  for (int i = 0; i < bombCount; i++) {
    int x = rand.nextInt(row);
    int y = rand.nextInt(col);
    if (board[x][y].hasBomb == false) {
      board[x][y].hasBomb = true;
    } else if (board[x][y].hasBomb) {
      i--;
    }
  }

  for (int i = 0; i < row; i++) {
    for (int j = 0; j < col; j++) {
      if (i > 0 && j > 0) {
        if (board[i - 1][j - 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (i > 0) {
        if (board[i - 1][j].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (i > 0 && j < col - 1) {
        if (board[i - 1][j + 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (j > 0) {
        if (board[i][j - 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (j < col - 1) {
        if (board[i][j + 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (i < row - 1 && j > 0) {
        if (board[i + 1][j - 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (i < row - 1) {
        if (board[i + 1][j].hasBomb) {
          board[i][j].bombsAround++;
        }
      }

      if (i < row - 1 && j < col - 1) {
        if (board[i + 1][j + 1].hasBomb) {
          board[i][j].bombsAround++;
        }
      }
    }
  }
  return board;
}
