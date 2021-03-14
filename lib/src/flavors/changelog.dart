import 'package:marker/ast.dart';
import 'package:marker/src/ast/printable.dart';
import 'package:marker/src/flavors/original.dart';

/// Changelog uses a special kind of implicit links inside H2
class Release extends Node {
  @override
  String print(Context context) =>
      '## ' +
      children
          .map((node) => node is Link ? _ReleaseLink(node) : node)
          .map((node) => node.print(context))
          .join() +
      '\n';
}

class _ReleaseLink implements Printable {
  _ReleaseLink(this._link);

  final Link _link;

  @override
  String print(Context context) {
    final innerText = '[${_link.children.map((e) => e.print(context)).join()}]';
    var href = _link.attributes['href']!;
    final title = _link.attributes['title'];
    if (title != null) href += ' "$title"';
    context.references.add('$innerText: $href');
    return innerText;
  }
}

class ReleaseLink extends Node {
  @override
  String print(Context context) {
    final innerText = '[${super.print(context)}]';
    var href = attributes['href']!;
    if (attributes.containsKey('title')) {
      href += ' "${attributes['title']}"';
    }
    context.references.add('$innerText: $href');
    return innerText;
  }
}
