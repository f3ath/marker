import 'dart:convert';

import 'package:marker/ast.dart';

/// This is an implementation of the original markdown
/// https://daringfireball.net/projects/markdown/syntax
class Header extends Node {
  Header(this.level);

  final int level;

  @override
  String render(Context context) =>
      '${'#' * level} ${super.render(context)}${context.lineBreak}';
}

class Paragraph extends Node {
  @override
  String render(Context context) =>
      super.render(context) + context.lineBreak * 2;
}

class LineBreak extends Node {
  @override
  String render(Context context) => '  ${context.lineBreak}';
}

class BlockQuote extends Node {
  @override
  String render(Context context) =>
      super
          .render(context)
          .trim()
          .addLinePrefix('> ', context.lineBreak, trim: true) +
      context.lineBreak * 2;
}

class UnorderedList extends Node {
  @override
  String render(Context context) =>
      children.map((node) => '- ${node.render(context)}').join() +
      context.lineBreak;
}

class OrderedList extends Node {
  @override
  String render(Context context) =>
      children
          .asMap()
          .entries
          .map((e) => '${e.key + 1}. ${e.value.render(context)}')
          .join() +
      context.lineBreak;
}

class ListItem extends Node {
  @override
  String render(Context context) {
    if (children.isNotEmpty) {
      if (_isBlock(children.first)) {
        return _renderBlockChildren(context);
      }
    }
    return children
            .map((node) {
              if (node is OrderedList || node is UnorderedList) {
                // We have a sublist. It must be separated from the previous
                // text node and from other block elements.
                final indent = (node is UnorderedList) ? 2 : 4;
                return context.lineBreak +
                    node
                        .render(context)
                        .addLinePrefix(' ' * indent, context.lineBreak) +
                    context.lineBreak;
              }
              return node.render(context);
            })
            .join()
            .trim() +
        context.lineBreak;
  }

  String _renderBlockChildren(Context context) =>
      children
          .map((node) {
            if (node is BlockQuote) {
              return node
                  .render(context)
                  .addLinePrefix(' ' * 4, context.lineBreak);
            }
            if (node is Pre) {
              // A code block in a list gets 3 spaces
              // despite the standard requiring 4.
              // @see https://daringfireball.net/projects/markdown/syntax#list
              // So we have to compensate here.
              return node
                  .render(context)
                  .addLinePrefix(' ' * 3, context.lineBreak);
            }
            return ' ' * 4 + node.render(context).trim();
          })
          .join(context.lineBreak * 2)
          .trim() +
      context.lineBreak * 2;

  bool _isBlock(node) =>
      node is Header ||
      node is Paragraph ||
      node is BlockQuote ||
      node is OrderedList ||
      node is UnorderedList;
}

class Pre extends Node {}

class Code extends Node {
  final _buf = StringBuffer();

  @override
  String render(Context context) {
    final text = _buf.toString();
    if (text.contains(context.lineBreak)) {
      return text.addLinePrefix(' ' * 4, context.lineBreak);
    }
    final fencing = _detectFencing(text);
    return fencing + text + fencing;
  }

  @override
  void addText(String text) => _buf.write(text);

  String _detectFencing(String text) {
    var fencing = '';
    do {
      fencing += '`';
    } while (text.contains(fencing));
    return fencing;
  }
}

class HorizontalRule extends Node {
  @override
  String render(Context context) => '---${context.lineBreak}';
}

class Emphasis extends Node {
  Emphasis(this.mark);

  final String mark;

  @override
  String render(Context context) => '$mark${super.render(context)}$mark';
}

class Link extends Node {
  @override
  String render(Context context) {
    final innerText = '[${super.render(context)}]';
    var href = attributes['href']!;
    if (attributes.containsKey('title')) {
      href += ' "${attributes['title']}"';
    }

    if (context.inlineLinks) {
      return '$innerText($href)';
    }
    final id = '[id${_id++}]';
    context.references.add('$id: $href');
    return '$innerText$id';
  }
}

class Image extends Node {
  @override
  String render(Context context) {
    var src = attributes['src']!;
    if (attributes.containsKey('title')) {
      src += ' "${attributes['title']}"';
    }
    final alt = attributes['alt'] ?? '';
    if (context.inlineImages) {
      return '![$alt]($src)';
    }
    final id = '[id${_id++}]';
    context.references.add('$id: $src');
    return '![$alt]$id';
  }
}

int _id = 1; // id generator for images and links

extension _StringExt on String {
  static const _splitter = LineSplitter();

  /// Adds [prefix] to all lines in the string.
  addLinePrefix(String prefix, String lineBreak, {bool trim = false}) =>
      _splitter
          .convert(this)
          .map((_) => prefix + _)
          .map((_) => trim ? _.trim() : _)
          .join(lineBreak);
}
