import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';
import 'package:test/test.dart';

void main() {
  test('Renderer', () {
    final example = File('test/example.md');
    final nodes = Document().parseLines(example.readAsLinesSync());
    final renderer = new Renderer();
    final text = renderer.render(nodes);
    final expected = Logger();
    nodes.forEach((n) => n.accept(expected));
    final actual = Logger();
    Document().parseLines(text.split('\n')).forEach((n) => n.accept(actual));
    expect(actual.buffer.toString(), expected.buffer.toString());
  });
}

class Logger implements NodeVisitor {
  final buffer = StringBuffer();

  @override
  void visitText(Text text) {
    buffer.write(text.textContent);
  }

  @override
  void visitElementAfter(Element element) {
    buffer.writeln('< ${element.tag} ${element.attributes}');
  }

  @override
  bool visitElementBefore(Element element) {
    buffer.writeln('> ${element.tag} ${element.attributes}');
    return true;
  }
}
