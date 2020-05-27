import 'package:marker/ast.dart';
import 'package:marker/src/flavors/original.dart' as orig;

class ReleaseLink extends Node {
  @override
  String render(Context context) {
    final innerText = '[${super.render(context)}]';
    var href = attributes['href'];
    if (attributes.containsKey('title')) {
      href += ' "${attributes['title']}"';
    }
    context.references.add('$innerText: ${href}');
    return '${innerText}';
  }
}

/// Changelog uses a special kind of implicit links inside H2
class Release extends Node {
  @override
  String render(Context context) {
    final _buf = StringBuffer('## ');
    children.forEach((node) {
      if (node is orig.Link) {
        final link = ReleaseLink()
          ..attributes.addAll(node.attributes)
          ..children.addAll(node.children);
        _buf.write(link.render(context));
      } else {
        _buf.write(node.render(context));
      }
    });
    _buf.write('\n');
    return _buf.toString();
  }
}
