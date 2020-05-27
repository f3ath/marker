import 'package:markdown/markdown.dart' as md;

/// Provides the rendering context.
class Context {
  Context(this.inlineImages, this.inlineLinks);

  /// Whether the images should be rendered inline (or as references)
  final bool inlineImages;

  /// Whether the links should be rendered inline (or as references)
  final bool inlineLinks;

  /// Accumulates references to images and links generated during rendering.
  /// When the rendering is done, these lines will be added to the bottom
  /// of the generated document.
  final List<String> references = [];
}

/// Builds the rendering tree by visiting the parsed nodes.
/// The [flavor] maps the element tags to [NodeConstructor]. For every
/// element in the parsed tree [NodeConstructor] produces a node of
/// the rendering tree. The special '_' key should contain a constructor
/// for the root node.
class Builder implements md.NodeVisitor {
  Builder(this.flavor) {
    _stack.add(flavor['_']());
  }

  final Map<String, NodeConstructor> flavor;
  final List<Node> _stack = [];

  /// Contains the root of the rendering tree
  Node get root => _stack.last;

  @override
  void visitText(md.Text text) {
    _stack.last.addText(text.textContent);
  }

  @override
  void visitElementAfter(md.Element element) {
    final node = _stack.last;
    _stack.removeLast();
    _stack.last.children.add(node);
  }

  @override
  bool visitElementBefore(md.Element element) {
    final tag = element.tag;
    final node = flavor.containsKey(tag) ? flavor[tag]() : flavor['_']();
    node.attributes.addAll(element.attributes);
    _stack.add(node);
    return true;
  }
}

typedef NodeConstructor = Node Function();

/// The base interface for the rendering tree nodes.
abstract class PrintableNode {
  /// Renders the node into markdown according to [context].
  String render(Context context);

  /// Adds a text node from the parsed tree.
  void addText(String text);
}

/// This is the internal text node. Accumulates text content.
class Text implements PrintableNode {
  final _buf = StringBuffer();

  @override
  void addText(String text) => _buf.write(text);

  /// Escapes common markdown special characters if those could be
  /// misinterpreted.
  @override
  String render(Context context) => _buf
      .toString()
      // dot after a number in the beginning of the string is a list item
      .replaceAllMapped(RegExp(r'^(\d+)\. '), (m) => '${m[1]}\\. ')
      // Special markdown chars: emphasis, strikethrough, table cell, links
      .replaceAllMapped(RegExp(r'[*_~|\[\]]'), (m) => '\\${m[0]}')
      // + and - in the beginning of the string is a list item
      .replaceAllMapped(RegExp(r'^[+-] '), (m) => '\\${m[0]}')
      // # in the beginning of the string is a header
      .replaceAllMapped(RegExp(r'^#'), (m) => '\\${m[0]}');
}

/// The base rendering tree node.
class Node implements PrintableNode {
  /// Node's children
  final List<PrintableNode> children = [];

  /// Attributes are copied from the corresponding parsed tree
  /// during tree building.
  final Map<String, String> attributes = {};

  /// Renders all children and returns concatenated output.
  @override
  String render(Context context) {
    final b = StringBuffer();
    children.forEach((node) => b.write(node.render(context)));
    return b.toString();
  }

  /// The standard markdown parser splits text content into several text nodes
  /// when it encounters the escape character. This method combines those
  /// text pieces into one to enable proper escaping.
  @override
  void addText(String text) {
    if (children.isNotEmpty) {
      final last = children.last;
      if (last is Text) {
        last.addText(text);
        return;
      }
    }
    children.add(Text()..addText(text));
  }
}
