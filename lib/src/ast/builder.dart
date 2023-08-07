import 'package:markdown/markdown.dart' as md;
import 'package:marker/src/ast/node.dart';

/// Builds the rendering tree by visiting the parsed nodes.
/// The [flavor] maps the element tags to [Node] producers. For every
/// element in the parsed tree the [Node] producer returns a node of
/// the rendering tree.
class Builder implements md.NodeVisitor {
  Builder(this.flavor);

  final Map<String, Node Function()> flavor;
  final _stack = [Node()];

  /// Contains the root of the rendering tree
  Node get root => _stack.last;

  @override
  void visitText(md.Text text) {
    _stack.last.addText(text.text);
  }

  @override
  void visitElementAfter(md.Element element) {
    final node = _stack.last;
    _stack.removeLast();
    _stack.last.addChild(node);
  }

  @override
  bool visitElementBefore(md.Element element) {
    final node = flavor[element.tag]?.call() ?? Node();
    node.attributes.addAll(element.attributes);
    _stack.add(node);
    return true;
  }
}
