import 'package:markdown/src/ast.dart';
import 'package:markdown_printer/src/default_ruleset.dart';
import 'package:markdown_printer/src/visitor.dart';

class Renderer {
  Renderer([Rules rules]) : rules = rules ?? DefaultRules();
  final Rules rules;

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
