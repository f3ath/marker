import 'package:marker/ast.dart';

/// This is an implementation of the original markdown
/// https://daringfireball.net/projects/markdown/syntax
class Header extends Node {
  Header(this.level);

  final int level;

  @override
  String print(Context context) =>
      '#' * level + ' ${super.print(context)}' + context.lineBreak;
}

class Paragraph extends Node {
  @override
  String print(Context context) => super.print(context) + context.lineBreak * 2;
}

class LineBreak extends Node {
  @override
  String print(Context context) => '  ' + context.lineBreak;
}

class BlockQuote extends Node {
  @override
  String print(Context context) =>
      super
          .print(context)
          .trim()
          .split(context.lineBreak)
          .map((line) => ('> ' + line).trim())
          .join(context.lineBreak) +
      context.lineBreak * 2;
}

class UnorderedList extends Node {
  @override
  String print(Context context) =>
      children.map((node) => '- ${node.print(context)}').join() +
      context.lineBreak;
}

class OrderedList extends Node {
  @override
  String print(Context context) =>
      children
          .asMap()
          .entries
          .map((e) => '${e.key + 1}. ${e.value.print(context)}')
          .join() +
      context.lineBreak;
}

class ListItem extends Node {
  @override
  String print(Context context) {
    if (children.isNotEmpty && _isBlock(children.first)) {
      return children
              .map((node) {
                if (node is BlockQuote) {
                  return '    ' +
                      node
                          .print(context)
                          .split(context.lineBreak)
                          .join(context.lineBreak + '    ');
                }
                if (node is Pre) {
                  // A code block in a list gets 3 spaces
                  // despite the standard requiring 4.
                  // @see https://daringfireball.net/projects/markdown/syntax#list
                  // So we have to compensate here.
                  return ' ' * 3 +
                      node
                          .print(context)
                          .split(context.lineBreak)
                          .join(context.lineBreak + ' ' * 3);
                }
                return ' ' * 4 + node.print(context).trim();
              })
              .join(context.lineBreak * 2)
              .trim() +
          context.lineBreak * 2;
    }
    return super.print(context) + context.lineBreak;
  }
}

class Pre extends Node {}

class Code extends Node {
  final _buf = StringBuffer();

  @override
  String print(Context context) {
    final text = _buf.toString();
    if (text.contains(context.lineBreak)) {
      return ' ' * 4 +
          text.split(context.lineBreak).join(context.lineBreak + ' ' * 4);
    }
    var fencing = 1;
    while (text.contains('`' * fencing)) {
      fencing++;
    } // Figure out the fencing length
    return '`' * fencing + text + '`' * fencing;
  }

  @override
  void addText(String text) => _buf.write(text);
}

class HorizontalRule extends Node {
  @override
  String print(Context context) => '---' + context.lineBreak;
}

class Emphasis extends Node {
  Emphasis(this.mark);

  final String mark;

  @override
  String print(Context context) => '$mark${super.print(context)}$mark';
}

class Link extends Node {
  @override
  String print(Context context) {
    final innerText = '[${super.print(context)}]';
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
  String print(Context context) {
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

bool _isBlock(node) =>
    node is Header ||
    node is Paragraph ||
    node is BlockQuote ||
    node is OrderedList ||
    node is UnorderedList;
