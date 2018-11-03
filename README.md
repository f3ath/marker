# marker

Marker is a Markdown renderer (printer) for Dart. It takes a list of `Node` objects produced by
the [parser](https://pub.dartlang.org/packages/markdown) and renders it back to a string.

Supported markdown flavors:
- [original](https://daringfireball.net/projects/markdown/syntax)
- changelog
- any custom flavor

The renderer supports both inline and reference links and images.

#### Example (from [changelog.dart](./example/changelog.dart))
```dart
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

```
