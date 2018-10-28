import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';

void main() {
  final changelog = File('CHANGELOG.md');

  final nodes = Document()
      // Parse the file content into a list of nodes
      .parseLines(changelog.readAsLinesSync())
      // Replace all 1st level `ul` with `ol`
      .map(convertUlToOl)
      // Convert back to a list
      .toList();

  // Render the modified nodes back to text and print
  print(Renderer().render(nodes));
}

Node convertUlToOl(Node node) {
  if (node is Element && node.tag == 'ul') {
    return Element('ol', node.children)..attributes.addAll(node.attributes);
  }
  return node;
}
