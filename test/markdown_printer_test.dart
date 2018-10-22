import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Printer', () {
    final renderer = Renderer();
    Directory('test/md').listSync().forEach((f) {
      final md = File(f.path);
      final nodes = Document().parseLines(md.readAsLinesSync());
      test(f.path, () {
        print(render(nodes, renderer).toString());
      });
    });
  });
}

String render(List<Node> nodes, Renderer renderer) {
  final buffer = StringBuffer();
  final visitor = VisitorAdapter(renderer, buffer);
  nodes.forEach((n) => n.accept(visitor));
  return buffer.toString();
}

typedef void RenderBlock(String text, StringBuffer buffer);
typedef String RenderInline(String text);

class VisitorAdapter implements NodeVisitor {
  VisitorAdapter(this.r, this._buffer)
      : _block = {
          'h1': r.h1,
          'h2': r.h2,
          'h3': r.h3,
          'h4': r.h4,
          'h5': r.h5,
          'h6': r.h6,
          'p': r.paragraph,
        },
        _inline = {
          'strong': r.strong,
          'em': r.em,
        };
  final Renderer r;
  StringBuffer _buffer;
  final Map<String, RenderBlock> _block;
  final Map<String, RenderInline> _inline;
  final List<StringBuffer> _stack = [];

  void visitText(Text text) => _buffer.write(text.textContent);

  void visitElementAfter(Element element) {
    final tag = element.tag;
    final text = _buffer.toString();
    _buffer = _stack.removeLast();
    if (_block.containsKey(tag)) {
      _block[tag](text, _buffer);
    } else if (_inline.containsKey(tag)) {
      _buffer.write(_inline[tag](text));
    } else if (tag == 'a') {
      _buffer.write(r.inlineLink(Link(text, element.attributes['href'])));
    }
  }

  bool visitElementBefore(Element element) {
    _stack.add(_buffer);
    _buffer = StringBuffer();
    return true;
  }
}

class Link {
  Link(this.text, this.url, {this.title = ''});

  final String text;
  final String url;
  final String title;
}

class Renderer {
  final _links = List<Link>();

  void h1(String text, StringBuffer buffer) => buffer.writeln('# $text');

  void h2(String text, StringBuffer buffer) => buffer.writeln('## $text');

  void h3(String text, StringBuffer buffer) => buffer.writeln('### $text');

  void h4(String text, StringBuffer buffer) => buffer.writeln('#### $text');

  void h5(String text, StringBuffer buffer) => buffer.writeln('##### $text');

  void h6(String text, StringBuffer buffer) => buffer.writeln('###### $text');

  void paragraph(String text, StringBuffer buffer) {
    buffer.writeln(text);
    buffer.writeln();
  }

  void links(StringBuffer buffer) => _links.map((link) {
        if (link.title.isEmpty) {
          return '[${link.text}]: ${link.url}';
        } else {
          return '[${link.text}]: ${link.url} (${link.title})';
        }
      }).forEach(buffer.writeln);

  String strong(String text) => '**${text}**';

  String em(String text) => '*${text}*';

  String inlineLink(Link link) {
    _links.add(link);
    if (link.title.isEmpty) return '[${link.text}](${link.url})';
    return '[${link.text}](${link.url} ${link.title})';
  }

  String blockLink(Link link) {
    _links.add(link);
    return '[${link.text}]';
  }
}
