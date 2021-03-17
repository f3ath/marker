import 'package:markdown/markdown.dart' as md;
import 'package:marker/ast.dart';
import 'package:marker/flavors.dart' as flavors;
import 'package:marker/src/ast/builder.dart';

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
    Map<String, Node Function()>? flavor}) {
  final context = Context(inlineImages, inlineLinks);
  final builder = Builder(flavor ?? flavors.original);
  nodes.forEach((node) => node.accept(builder));
  return (builder.root.print(context) + context.references.join('\n')).trim();
}
