import 'package:markdown/markdown.dart' as md;
import 'package:marker/ast.dart';
import 'package:marker/flavors.dart' as flavors;

/// Renders the given list of [nodes] into a markdown string.
/// [inlineLinks] and [inlineImages] flags control whether the images and links
/// will be rendered inline or as references.
/// The [flavor] allows to modify the renderer's behavior,
/// see [Builder] for details. By default, the
/// [original](https://daringfireball.net/projects/markdown) markdown
/// flavor will be used.
String render(Iterable<md.Node> nodes,
    {bool inlineImages = true,
    bool inlineLinks = true,
    String lineBreak = '\n',
    Map<String, Node Function()>? flavor}) {
  final context = Context(inlineImages, inlineLinks, lineBreak: lineBreak);
  final builder = Builder(flavor ?? flavors.original);
  for (final node in nodes) {
    node.accept(builder);
  }
  return (builder.root.render(context) +
          context.references.join(context.lineBreak))
      .trim();
}
