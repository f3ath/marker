import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';
import 'package:test/test.dart';

void main() {
  Directory('test/standard/inline').listSync().forEach((f) {
    if (f is File) {
      final nodes = Document(extensionSet: ExtensionSet.none)
          .parseLines(f.readAsLinesSync());
      final text = render(nodes);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });

  Directory('test/standard/reference').listSync().forEach((f) {
    if (f is File) {
      final nodes = Document(extensionSet: ExtensionSet.none)
          .parseLines(f.readAsLinesSync());
      final text = render(nodes, inlineImages: false, inlineLinks: false);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });
}
