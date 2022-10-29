import 'dart:math';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

import '/src/core/object.dart';
import '/src/util/extension.dart';

/// Dialog as a [NovelObject].
class Dialogue extends NovelObject with GuardedMixin {
  Dialogue({
    this.by,
    required this.text,
  });

  final String? by;
  final String text;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      key: key,
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: unlock,
        child: _DialogueWidget(text: text, by: by),
      ),
    );
  }
}

class _DialogueWidget extends StatefulWidget {
  const _DialogueWidget({
    Key? key,
    this.by,
    required this.text,
  }) : super(key: key);

  final String? by;
  final String text;

  @override
  State<_DialogueWidget> createState() => _DialogueWidgetState();
}

class _DialogueWidgetState extends State<_DialogueWidget> {
  int _i = 0;
  String _text = '';

  @override
  void initState() {
    _progress();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _DialogueWidget oldWidget) {
    if (oldWidget.text != widget.text) {
      _i = 0;
      _text = '';
      _progress();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const Key('Dialog'),
      builder: (context, constraints) {
        const Color outline1 = Color(0xFF613400);
        const Color outline2 = Color(0xFF713D00);

        return Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: max(60, constraints.maxHeight * 0.3),
              ),
              height: 285,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00D7FAFC),
                    Color(0xFF81A6CD),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  margin: EdgeInsets.symmetric(
                    horizontal: context.isMobile ? 10 : 100,
                  ),
                  width: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BorderedText(
                          strokeColor: outline1,
                          strokeWidth: 8,
                          child: Text(
                            widget.by ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFFFFC700),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: BorderedText(
                              strokeColor: outline2,
                              strokeWidth: 6,
                              child: Text(
                                _text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _progress() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted) {
        if (_i >= widget.text.length) {
          setState(() => _text = '$_text」');
        } else {
          ++_i;
          setState(() => _text = '「${widget.text.substring(0, _i)}');

          if (_i <= widget.text.length) {
            _progress();
          } else {
            _text = '$_text」';
          }
        }
      }
    });
  }
}
