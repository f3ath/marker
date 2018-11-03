import 'package:markdown/markdown.dart' as md;
import 'package:marker/marker.dart';

class Builder implements md.NodeVisitor {
  Builder(this._factory) {
    _stack.add(_factory['_']());
  }

  final Map<String, NodeConstructor> _factory;
  final List<Node> _stack = [];

  Node get root => _stack.last;

  @override
  void visitText(md.Text text) {
    _stack.last.addText(text.textContent);
  }

  @override
  void visitElementAfter(md.Element element) {
    final node = _stack.last;
    _stack.removeLast();
    _stack.last.addChild(node);
  }

  @override
  bool visitElementBefore(md.Element element) {
    final tag = element.tag;
    final node = _factory.containsKey(tag) ? _factory[tag]() : _factory['_']();
    node.attributes.addAll(element.attributes);
    _stack.add(node);
    return true;
  }
}

typedef Node NodeConstructor();

abstract class Printable {
  String render(Context context);

  void addText(String text);
}

class Text implements Printable {
  final _buf = StringBuffer();

  Text(String text) {
    _buf.write(text);
  }

  addText(String text) => _buf.write(text);

  render(Context context) => _buf
      .toString()
      // dot after a number
      .replaceAllMapped(RegExp(r'^(\d+)\. '), (m) => '${m[1]}\\. ')
      //
      .replaceAllMapped(RegExp(r'[*_]'), (m) => '\\${m[0]}');
}

class Node implements Printable {
  final List<Printable> _children = [];

  final Map<String, String> attributes = {};

  void addChild(Node node) => _children.add(node);

  Iterable<Printable> get children => List.from(_children);

  render(Context context) {
    final b = StringBuffer();
    children.forEach((node) => b.write(node.render(context)));
    return b.toString();
  }

  addText(String text) {
    if (_children.isNotEmpty) {
      final last = _children.last;
      if (last is Text) {
        last.addText(text);
        return;
      }
    }
    _children.add(Text(text));
  }
}
