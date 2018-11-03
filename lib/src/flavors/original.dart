import 'package:marker/ast.dart';

/**
 * This is an implementation of the original markdown
 * https://daringfireball.net/projects/markdown/syntax
 */

class Header extends Node {
  final int level;

  Header(this.level);

  render(Context context) => '#' * level + ' ${super.render(context)}\n';
}

class Paragraph extends Node {
  render(Context context) => super.render(context) + '\n\n';
}

class LineBreak extends Node {
  render(Context context) => '  \n';
}

class BlockQuote extends Node {
  render(Context context) =>
      super
          .render(context)
          .trim()
          .split('\n')
          .map((line) => ('> ' + line).trim())
          .join('\n') +
      '\n\n';
}

class UnorderedList extends Node {
  render(Context context) =>
      children.map((node) => '- ${node.render(context)}').join() + '\n';
}

class OrderedList extends Node {
  render(Context context) {
    int i = 1;
    return children.map((node) => '${i++}. ${node.render(context)}').join() +
        '\n';
  }
}

class ListItem extends Node {
  render(Context context) {
    if (children.isNotEmpty && _isBlock(children.first)) {
      return children
              .map((node) {
                if (node is BlockQuote) {
                  return '    ' +
                      node.render(context).split('\n').join('\n    ');
                }
                if (node is Pre) {
                  // A code block in a list gets 3 spaces
                  // despite the standard requiring 4.
                  // @see https://daringfireball.net/projects/markdown/syntax#list
                  // So we have to compensate here.
                  return '   ' + node.render(context).split('\n').join('\n   ');
                }
                return '    ' + node.render(context).trim();
              })
              .join('\n\n')
              .trim() +
          '\n\n';
    }
    return super.render(context) + '\n';
  }
}

class Pre extends Node {}

class Code extends Node {
  final _buf = StringBuffer();

  render(Context context) {
    final text = _buf.toString();
    if (text.contains('\n')) return '    ' + text.split('\n').join('\n    ');
    int fencing = 1;
    while (text.contains('`' * fencing))
      fencing++; // Figure out the fencing length
    return '`' * fencing + text + '`' * fencing;
  }

  addText(String text) => _buf.write(text);
}

class HorizontalRule extends Node {
  render(Context context) => '---\n';
}

class Emphasis extends Node {
  Emphasis(this.mark);

  final String mark;

  render(Context context) => '${mark}${super.render(context)}${mark}';
}

class Link extends Node {
  render(Context context) {
    final innerText = '[${super.render(context)}]';
    String href = attributes['href'];
    if (attributes.containsKey('title')) {
      href += ' "${attributes['title']}"';
    }

    if (context.inlineLinks) {
      return '${innerText}(${href})';
    }
    final id = '[id${_id++}]';
    context.references.add('$id: ${href}');
    return '${innerText}${id}';
  }
}

class Image extends Node {
  render(Context context) {
    String src = attributes['src'];
    if (attributes.containsKey('title')) {
      src += ' "${attributes['title']}"';
    }
    final alt = attributes['alt'] ?? '';
    if (context.inlineImages) {
      return '![$alt](${src})';
    }
    final id = '[id${_id++}]';
    context.references.add('${id}: ${src}');
    return '![${alt}]${id}';
  }
}

int _id = 1; // id generator for images and links

_isBlock(node) =>
    node is Header ||
    node is Paragraph ||
    node is BlockQuote ||
    node is OrderedList ||
    node is UnorderedList;
