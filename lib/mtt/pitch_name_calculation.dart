import 'dart:math';
import 'package:flutter/material.dart';
import 'base.dart';

class PitchNameCalculationAnswer implements Answer {
  PitchNameCalculationAnswer(this.pitchName);

  String pitchName;
}

class PitchNameCalculationQuestion
    implements Question<PitchNameCalculationAnswer> {
  PitchNameCalculationQuestion() {
    final Random random = Random.secure();
    _basePitchIndex = random.nextInt(pitchNames.length - 1);
    _isPlus = random.nextBool();
    _delta = random.nextInt(pitchNames.length) + 1;
    if (_isPlus) {
      _answerPitchIndex = _basePitchIndex + _delta;
    } else {
      _answerPitchIndex = _basePitchIndex - _delta;
    }
    _answerPitchIndex += pitchNames.length;
    _answerPitchIndex %= pitchNames.length;
  }

  static const String pitchNames = 'CDEFGAB';
  late int _basePitchIndex;
  late int _delta;
  late bool _isPlus;
  late int _answerPitchIndex;

  @override
  bool check(PitchNameCalculationAnswer answer) {
    return pitchNames[_answerPitchIndex] == answer.pitchName;
  }

  @override
  String toString() {
    final String opS = _isPlus ? '+' : '-';
    return '${(PitchNameCalculationQuestion).toString()}: $basePitchName $opS $_delta => $answerPitchName';
  }

  int get basePitchIndex => _basePitchIndex;

  String get basePitchName => pitchNames[_basePitchIndex];

  int get answerPitchIndex => _answerPitchIndex;

  String get answerPitchName => pitchNames[_answerPitchIndex];

  bool get isPlus => _isPlus;

  int get delta => _delta;
}

class PitchNameCalculationQuestionWidget extends StatefulWidget {
  const PitchNameCalculationQuestionWidget({Key? key}) : super(key: key);

  @override
  _PitchNameCalculationQuestionWidgetState createState() =>
      _PitchNameCalculationQuestionWidgetState();
}

class PitchNameCalculationQuestionDescription extends StatelessWidget {
  PitchNameCalculationQuestionDescription(this.question, {Key? key})
      : super(key: key);

  final PitchNameCalculationQuestion question;

  @override
  Widget build(BuildContext context) {
    String op;
    op = question.isPlus ? '+' : '-';
    Widget res = Text('${question.basePitchName} $op ${question.delta} = ?');
    return res;
  }
}

class _PitchNameCalculationQuestionWidgetState
    extends State<PitchNameCalculationQuestionWidget> {
  late PitchNameCalculationQuestion question;
  bool? ok;
  late List<String> randomNameList;

  _PitchNameCalculationQuestionWidgetState() {
    _init();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(PitchNameCalculationQuestionDescription(question));
    children.add(TextButton(
        onPressed: () {
          _reinit();
        },
        child: Text('下一个')));
    for (final String pitchName in randomNameList) {
      children.add(_buildPitchNameButton(pitchName));
    }
    if (ok != null) {
      if (ok!) {
        children.add(Text(
          'OK: ${question.answerPitchName}',
          style: TextStyle(color: Colors.green),
        ));
      } else {
        children.add(Text(
          'NO: ${question.answerPitchName}',
          style: TextStyle(color: Colors.red),
        ));
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              children: children),
        ],
      ),
    );
  }

  void _reinit() {
    setState(() {
      _init();
    });
  }

  void _init() {
    question = PitchNameCalculationQuestion();
    ok = null;
    randomNameList = PitchNameCalculationQuestion.pitchNames.split('')
      ..shuffle(Random.secure());
  }

  Widget _buildPitchNameButton(String pitchName) {
    TextButton res = TextButton(
      child: Text(pitchName),
      onPressed: () {
        setState(() {
          final PitchNameCalculationAnswer answer =
              PitchNameCalculationAnswer(pitchName);
          if (question.check(answer)) {
            ok = true;
          } else {
            ok = false;
          }
        });
      },
    );
    return res;
  }
}
