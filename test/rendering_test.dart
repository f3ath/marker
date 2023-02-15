import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/flavors.dart' as flavor;
import 'package:marker/marker.dart';
import 'package:test/test.dart';

void main() {
  Directory('test/original').listSync().forEach((f) {
    if (f is File) {
      final text = render(readNodes(f));
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });

  Directory('test/changelog').listSync().forEach((f) {
    if (f is File) {
      final text = render(readNodes(f), flavor: flavor.changelog);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });

  Directory('test/original/reference').listSync().forEach((f) {
    if (f is File) {
      final text =
          render(readNodes(f), inlineImages: false, inlineLinks: false);
      test(f.path, () => expect(text, f.readAsStringSync().trim()));
    }
  });
}

List<Node> readNodes(File file) => Document(
      extensionSet: ExtensionSet.none,
      encodeHtml: false,
    ).parseLines(file.readAsLinesSync());
