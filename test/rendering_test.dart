import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/flavors.dart' as flavor;
import 'package:marker/marker.dart';
import 'package:test/test.dart';

void main() {
  Directory('test/original/inline').listSync().forEach((f) {
    if (f is File) {
      final nodes = Document(extensionSet: ExtensionSet.none)
          .parseLines(f.readAsLinesSync());
      final text = render(nodes);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });

  Directory('test/original/reference').listSync().forEach((f) {
    if (f is File) {
      final nodes = Document(extensionSet: ExtensionSet.none)
          .parseLines(f.readAsLinesSync());
      final text = render(nodes, inlineImages: false, inlineLinks: false);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });

  Directory('test/changelog').listSync().forEach((f) {
    if (f is File) {
      final nodes = Document(extensionSet: ExtensionSet.none)
          .parseLines(f.readAsLinesSync());
      final text = render(nodes, flavor: flavor.changelog);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });
}
