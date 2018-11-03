import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';

/// Renders CHANGELOG.md with all links inline
void main() {
  final file = File('CHANGELOG.md');

  /// Contains parsed tree
  final nodes = Document().parseLines(file.readAsLinesSync());

  /// Contains markdown text
  final markdown = render(nodes);
  print(markdown);
}
