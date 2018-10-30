import 'package:markdown/src/ast.dart';
import 'package:marker/defaults.dart' as defaults;
import 'package:marker/src/visitor.dart';

/// Markdown renderer
class Renderer {
  /// To alter the [Renderer]'s behavior you can pass a custom [textPrinter]
  /// and a map of [elementPrinters] for every markdown tag.
  Renderer({this.textPrinter, this.elementPrinters});

  final TextPrinter textPrinter;
  final Map<String, ElementPrinter> elementPrinters;

  /// Renders the given [nodes] into a string.
  /// Images will be rendered as references if [inlineImages] is false.
  /// Links will be rendered as references if [inlineLinks] is false.
  String render(List<Node> nodes,
      {bool inlineImages = true, bool inlineLinks = true}) {
    final visitor = Visitor(textPrinter ?? defaults.textHandler,
        elementPrinters ?? defaults.elementHandlers, inlineImages, inlineLinks);
    nodes.forEach((node) => node.accept(visitor));
    visitor.dumpDelayed();
    return visitor.markdown;
  }
}

/// Rendering context
abstract class Context {
  /// True if images should be rendered inline.
  bool get inlineImages;

  /// True is links should be rendered inline.
  bool get inlineLinks;

  /// Current [path] in the DOM tree where the [path].last is the element
  /// being processed.
  List<Element> get path;

  /// Adds [text] to the output buffer after all nodes have been processed.
  writeDelayed(String text);
}

/// Prints a text node.
/// This function is called by the [NodeVisitor] for every text node.
/// It should escape special characters.
typedef String TextPrinter(String text, Context context);

/// Prints a markdown element with the given [attributes] and [innerMarkdown].
/// This function is called by [NodeVisitor] after it visits the element.
typedef String ElementPrinter(
    Map<String, String> attributes, String innerMarkdown, Context context);
