import 'package:markdown/markdown.dart';
import 'package:marker/defaults.dart' as def;
import 'package:marker/marker.dart';
import 'package:test/test.dart';

void main() {
  test('Reference links', () {
    final ctx = ContextMock();
    final rendered = def.elementHandlers['a'](
        {'href': 'https://example.com', 'title': 'Test title'},
        'Inner text',
        ctx);

    expect(rendered, '[Inner text][link1]');
    expect(ctx.delayed.last, '[link1]: https://example.com "Test title"');
  });

  test('Reference images', () {
    final ctx = ContextMock();
    final rendered = def.elementHandlers['img'](
        {'src': 'https://example.com', 'title': 'Test title'}, '', ctx);

    expect(rendered, '![img2]');
    expect(ctx.delayed.last, '![img2]: https://example.com "Test title"');
  });
}

class ContextMock implements Context {
  bool get inlineImages => false;

  bool get inlineLinks => false;

  final List<String> delayed = [];

  @override
  writeDelayed(String text) => delayed.add(text);

  List<Element> get path => [];
}
