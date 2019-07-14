import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  AudioCache audioCache = AudioCache();

  final Map<String, bool> score = {};

  final Map<String, Color> choices = {
    '🍋': Colors.yellow,
    '🍏': Colors.green,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    //'🍫': Colors.brown,
  };

  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ${score.length} / 4 '),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((emoji) {
              return score[emoji] == true
                  ? Emoji(
                      emoji: '✔️',
                    )
                  : Draggable<String>(
                      data: emoji,
                      child: Emoji(
                        emoji: score[emoji] == true ? '✔️' : emoji,
                      ),
                      feedback: Emoji(
                        emoji: emoji,
                      ),
                      childWhenDragging: Emoji(
                        emoji: '🌱',
                      ),
                    );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((emoji) {
              return _buildDragTarget(emoji);
            }).toList()
              ..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }

  Widget _buildDragTarget(String emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming,
          List<dynamic> rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {
        print('Rejected');
      },
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        //height: 50,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
