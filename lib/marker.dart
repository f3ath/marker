import 'package:markdown/src/ast.dart';
import 'package:marker/src/default_rules.dart';
import 'package:marker/src/visitor.dart';

/// Markdown renderer
class Renderer {
  /// Use [rules] to provide custom rendering rules.
  /// See [DefaultRules] for more details.
  Renderer([Rules rules]) : rules = rules ?? DefaultRules();
  final Rules rules;

  /// Renders the given [nodes] into string.
  String render(List<Node> nodes) {
    final visitor = Visitor(rules);
    nodes.forEach((node) => node.accept(visitor));
    return visitor.getMarkdown();
  }
}

abstract class Context {
  write(String text);
}

abstract class Rules {
  void onText(String text, Context context);

  void onEnter(Element element, Context context);

  void onExit(Element element, String accumulatedText, Context context);
}
