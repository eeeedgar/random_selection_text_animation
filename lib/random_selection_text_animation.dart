library random_selection_text_animation;

import 'package:flutter/material.dart';
import 'dart:math';

enum CharSet {
  all,
  englishAlphabetUpperCase,
  englishAlphabetLowerCase,
  digits,
  custom,
}

class LetterSelectionAnimatedText extends StatefulWidget {
  const LetterSelectionAnimatedText({
    super.key,
    required this.textWidget,
    this.customCharSet,
    this.charSets,
    this.framesPerSymbolChange = 2,
    this.symbolChangesPerPosition = 2,
    this.timeLimit,
  });

  final Text textWidget;
  final Set<CharSet>? charSets;
  final String? customCharSet;
  final int framesPerSymbolChange;
  final int symbolChangesPerPosition;
  final Duration? timeLimit;

  @override
  State<LetterSelectionAnimatedText> createState() =>
      _LetterSelectionAnimatedTextState();
}

class _LetterSelectionAnimatedTextState
    extends State<LetterSelectionAnimatedText>
    with SingleTickerProviderStateMixin<LetterSelectionAnimatedText> {
  late String _initialData;
  int _steps = 0;
  int _iteration = -1;
  late int _symbolChangesPerPosition;
  late int _framesPerSymbolChange;
  bool _notEnoughTime = false;

  final _englishAlphabetUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final _digits = '1234567890';
  final _rnd = Random();
  String _chars = '';

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _initialData = widget.textWidget.data ?? '';
    _symbolChangesPerPosition = widget.symbolChangesPerPosition;
    _framesPerSymbolChange = widget.framesPerSymbolChange;

    _createCharSet();

    _controller = AnimationController(
      vsync: this,
      duration: widget.timeLimit ?? Duration(seconds: _initialData.length),
    );
    _controller.addListener(_update);

    _controller.forward().whenComplete(
      () {
        setState(
          () {
            _notEnoughTime = true;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    if (_steps >
        _framesPerSymbolChange *
            _symbolChangesPerPosition *
            _initialData.length) {
      _controller.stop();
      return;
    }
    if (_steps % _framesPerSymbolChange == 0) {
      setState(() {
        _iteration++;
      });
    }
    _steps++;
  }

  @override
  Widget build(BuildContext context) {
    if (_notEnoughTime) {
      return Text(
        _initialData,
        style: widget.textWidget.style,
        strutStyle: widget.textWidget.strutStyle,
        textAlign: widget.textWidget.textAlign,
        textDirection: widget.textWidget.textDirection,
        locale: widget.textWidget.locale,
        softWrap: widget.textWidget.softWrap,
        overflow: widget.textWidget.overflow,
        textScaleFactor: widget.textWidget.textScaleFactor,
        maxLines: widget.textWidget.maxLines,
        semanticsLabel: widget.textWidget.semanticsLabel,
        textWidthBasis: widget.textWidget.textWidthBasis,
        textHeightBehavior: widget.textWidget.textHeightBehavior,
        selectionColor: widget.textWidget.selectionColor,
      );
    }

    final currentSymbolNumber = _iteration ~/ _symbolChangesPerPosition;

    final shownText = _initialData.substring(0, currentSymbolNumber) +
        _getRandomString(_initialData.length - currentSymbolNumber);

    return Text(
      shownText,
      style: widget.textWidget.style,
      strutStyle: widget.textWidget.strutStyle,
      textAlign: widget.textWidget.textAlign,
      textDirection: widget.textWidget.textDirection,
      locale: widget.textWidget.locale,
      softWrap: widget.textWidget.softWrap,
      overflow: widget.textWidget.overflow,
      textScaleFactor: widget.textWidget.textScaleFactor,
      maxLines: widget.textWidget.maxLines,
      semanticsLabel: widget.textWidget.semanticsLabel,
      textWidthBasis: widget.textWidget.textWidthBasis,
      textHeightBehavior: widget.textWidget.textHeightBehavior,
      selectionColor: widget.textWidget.selectionColor,
    );
  }

  String _getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  void _createCharSet() {
    final charSets = widget.charSets ?? Set.unmodifiable({CharSet.all});

    if (charSets.contains(CharSet.custom) && widget.customCharSet == null) {
      throw ArgumentError.value(widget.customCharSet, 'void _createCharSet()',
          'Selecting custom character set, you have to define it');
    }

    if (widget.customCharSet != null) {
      if (widget.customCharSet!.isEmpty) {
        throw ArgumentError.value(widget.customCharSet, 'void _createCharSet()',
            'You can\'t define a custom character set with an empty string');
      } else {
        _chars += widget.customCharSet!;
      }
    }

    if (charSets.contains(CharSet.all)) {
      _chars += _englishAlphabetUpperCase +
          _englishAlphabetUpperCase.toLowerCase() +
          _digits;
    } else {
      if (charSets.contains(CharSet.digits)) {
        _chars += _digits;
      }
      if (charSets.contains(CharSet.englishAlphabetLowerCase)) {
        _chars += _englishAlphabetUpperCase.toLowerCase();
      }
      if (charSets.contains(CharSet.englishAlphabetUpperCase)) {
        _chars += _englishAlphabetUpperCase;
      }
    }
  }
}
