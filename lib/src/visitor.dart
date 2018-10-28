import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';

class Visitor implements NodeVisitor, Context {
  Visitor(this.rules);

  final Rules rules;

  StringBuffer _buffer = StringBuffer();

  final List<StringBuffer> _bufferStack = [];
  final List<Element> _elementStack = [];

  @override
  void visitText(Text text) => rules.onText(text.textContent, this);

  @override
  void visitElementAfter(Element element) {
    final text = _buffer.toString();
    _buffer = _bufferStack.removeLast();
    rules.onExit(element, text, this);
    _elementStack.removeLast();
  }

  @override
  bool visitElementBefore(Element element) {
    _elementStack.add(element);
    _bufferStack.add(_buffer);
    _buffer = StringBuffer();
    rules.onEnter(element, this);
    return true;
  }

  write(String text) => _buffer.write(text);

  String getMarkdown() => _buffer.toString();
}
