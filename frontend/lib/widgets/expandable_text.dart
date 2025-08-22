import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 1,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.text,
          style: const TextStyle(color: Colors.black),
        );

        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: isExpanded || !isOverflowing
                    ? widget.text
                    : widget.text.substring(
                            0,
                            tp
                                .getPositionForOffset(
                                    Offset(constraints.maxWidth, tp.preferredLineHeight))
                                .offset) +
                        '...',
              ),
              if (isOverflowing)
                TextSpan(
                  text: isExpanded ? ' less' : ' more',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => setState(() => isExpanded = !isExpanded),
                ),
            ],
          ),
        );
      },
    );
  }
}
