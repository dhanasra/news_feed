import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HighlightedTextWidget extends LeafRenderObjectWidget {
  final String text;
  final String highlight;
  final TextStyle style;
  final TextStyle highlightStyle;

  const HighlightedTextWidget({
    super.key,
    required this.text,
    required this.highlight,
    this.style = const TextStyle(fontSize: 14, color: Colors.black),
    this.highlightStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
      backgroundColor: Color(0xFFFFE082),
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderHighlightedText(
      text: text,
      highlight: highlight,
      style: style,
      highlightStyle: highlightStyle,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderHighlightedText renderObject,
  ) {
    renderObject
      ..text = text
      ..highlight = highlight
      ..style = style
      ..highlightStyle = highlightStyle;
  }
}

class _RenderHighlightedText extends RenderBox {
  String _text;
  String _highlight;
  TextStyle _style;
  TextStyle _highlightStyle;

  _RenderHighlightedText({
    required String text,
    required String highlight,
    required TextStyle style,
    required TextStyle highlightStyle,
  })  : _text = text,
        _highlight = highlight,
        _style = style,
        _highlightStyle = highlightStyle;

  set text(String v) { _text = v; markNeedsLayout(); }
  set highlight(String v) { _highlight = v; markNeedsPaint(); }
  set style(TextStyle v) { _style = v; markNeedsLayout(); }
  set highlightStyle(TextStyle v) { _highlightStyle = v; markNeedsPaint(); }

  List<TextSpan> _buildSpans() {
    if (_highlight.isEmpty) return [TextSpan(text: _text, style: _style)];
    final lower = _text.toLowerCase();
    final hlLower = _highlight.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    while ((idx = lower.indexOf(hlLower, start)) != -1) {
      if (idx > start) spans.add(TextSpan(text: _text.substring(start, idx), style: _style));
      spans.add(TextSpan(text: _text.substring(idx, idx + _highlight.length), style: _highlightStyle));
      start = idx + _highlight.length;
    }
    if (start < _text.length) spans.add(TextSpan(text: _text.substring(start), style: _style));
    return spans;
  }

  @override
  void performLayout() {
    final painter = TextPainter(
      text: TextSpan(children: _buildSpans()),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.maxWidth);
    size = constraints.constrain(Size(painter.width, painter.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(children: _buildSpans()),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    painter.paint(context.canvas, offset);
  }
}