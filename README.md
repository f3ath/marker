# marker

Marker is a Markdown renderer (printer) for Dart. It takes a list of `Node` objects produced by
the [parser](https://pub.dartlang.org/packages/markdown) and renders it back to `String`.

#### Example (from [change_list.dart](./example/change_list.dart))
The following code displays the contents of `CHANGELOG.md` with all first-level
unordered lists changed into ordered ones.
```dart
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
```

## Custom rendering rules
The `Renderer()` constructor accepts optional arguments which can be used to alter its behavior.

## Known issues
- The default rules may not process all tags properly. Please open an issue in this case.
- Some special characters (e.g. `*` or `[]`) may not be escaped in the resulting text. A more intelligent
 escaping logic is work in progress.