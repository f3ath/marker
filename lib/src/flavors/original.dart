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
    if (children.isNotEmpty && _isBlock(children.first)) {
      return _renderBlockChildren(context);
    }
    return children
            .map((node) => switch (node) {
                  OrderedList() ||
                  UnorderedList() =>
                    // We have a sublist. It must be separated from the previous
                    // text node and from other block elements.
                    context.lineBreak +
                        node.render(context).addLinePrefix(
                            ' ' * ((node is UnorderedList) ? 2 : 4),
                            context.lineBreak) +
                        context.lineBreak,
                  _ => node.render(context)
                })
            .join()
            .trim() +
        context.lineBreak;
  }

  String _renderBlockChildren(Context context) =>
      children
          .map((node) => switch (node) {
                BlockQuote() => node
                    .render(context)
                    .addLinePrefix(' ' * 4, context.lineBreak),
                Pre() =>
                  // A code block in a list gets 3 spaces
                  // despite the standard requiring 4.
                  // @see https://daringfireball.net/projects/markdown/syntax#list
                  // So we have to compensate here.
                  node
                      .render(context)
                      .addLinePrefix(' ' * 3, context.lineBreak),
                _ => ' ' * 4 + node.render(context).trim()
              })
          .join(context.lineBreak * 2)
          .trim() +
      context.lineBreak * 2;

  bool _isBlock(node) => switch (node) {
        Header() ||
        Paragraph() ||
        BlockQuote() ||
        OrderedList() ||
        UnorderedList() =>
          true,
        _ => false
      };
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
    return text.fenced('`');
  }

  @override
  void addText(String text) => _buf.write(text);
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
    if (attributes case {'title': String title}) {
      href += ' "$title"';
    }
    if (context.inlineLinks) {
      return '$innerText($href)';
    }
    final id = context.nextId();
    context.ref[id] = href;
    return '$innerText[$id]';
  }
}

class Image extends Node {
  @override
  String render(Context context) {
    var src = attributes['src']!;
    if (attributes case {'title': String title}) {
      src += ' "$title"';
    }
    final alt = attributes['alt'] ?? '';
    if (context.inlineImages) {
      return '![$alt]($src)';
    }
    final id = context.nextId();
    context.ref[id] = src;
    return '![$alt][$id]';
  }
}

extension _StringExt on String {
  static const _splitter = LineSplitter();

  /// Adds [prefix] to all lines in the string.
  addLinePrefix(String prefix, String lineBreak, {bool trim = false}) =>
      _splitter
          .convert(this)
          .map((it) => prefix + it)
          .map((it) => trim ? it.trim() : it)
          .join(lineBreak);

  String fenced(String block) {
    var fence = '';
    do {
      fence += block;
    } while (contains(fence));
    return fence + this + fence;
  }
}
