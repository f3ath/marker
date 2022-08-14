import 'package:marker/ast.dart';
import 'package:marker/src/ast/renderable.dart';
import 'package:marker/src/flavors/original.dart';

/// Changelog uses a special kind of implicit links inside H2
class Release extends Node {
  @override
  String render(Context context) => '## ${_title(context)}${context.lineBreak}';

  String _title(Context context) => children
      .map((it) => it is Link ? _Link(it) : it)
      .map((it) => it.render(context))
      .join();
}

class _Link implements Renderable {
  _Link(this._link);

  final Link _link;

  @override
  String render(Context context) {
    final innerText =
        '[${_link.children.map((e) => e.render(context)).join()}]';
    var href = _link.attributes['href']!;
    final title = _link.attributes['title'];
    if (title != null) href += ' "$title"';
    context.references.add('$innerText: $href');
    return innerText;
  }
}
