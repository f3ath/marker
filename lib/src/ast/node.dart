import 'package:marker/src/ast/context.dart';
import 'package:marker/src/ast/renderable.dart';
import 'package:marker/src/ast/text.dart';

/// The base rendering tree node.
class Node implements Renderable {
  /// Node's children
  final List<Renderable> children = [];

  /// Attributes are copied from the corresponding parsed tree
  /// during tree building.
  final Map<String, String> attributes = {};

  /// Renders all children and returns concatenated output.
  @override
  String render(Context context) =>
      children.map((node) => node.render(context)).join();

  /// Adds a child text node
  void addText(String text) {
    children.add(Text(text));
  }

  /// Adds a child text node
  void addChild(Node node) {
    children.add(node);
  }
}
