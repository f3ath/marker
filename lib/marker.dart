import 'package:markdown/markdown.dart' as md;
import 'package:marker/ast.dart';
import 'package:marker/flavors.dart' as flavors;

String render(List<md.Node> nodes,
    {bool inlineImages = true,
    bool inlineLinks = true,
    Map<String, NodeConstructor> flavor}) {
  final context = Context(inlineImages, inlineLinks);
  final builder = Builder(flavor ?? flavors.standard);
  nodes.forEach((node) => node.accept(builder));
  return (builder.root.render(context) + context.footer.join('\n')).trim();
}

class Context {
  Context(this.inlineImages, this.inlineLinks);

  final bool inlineImages;

  final bool inlineLinks;

  final List<String> footer = [];
}
