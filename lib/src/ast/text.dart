import 'package:marker/src/ast/context.dart';
import 'package:marker/src/ast/renderable.dart';

class Text implements Renderable {
  Text(this.text);

  static final _header = RegExp(r'^#');
  static final _orderedListItem = RegExp(r'^(\d+)\. ');
  static final _specialChars = RegExp(r'[*_~|\[\]]');
  static final _unorderedListItem = RegExp(r'^[+-] ');

  final String text;

  /// Escapes common markdown special characters if those could be
  /// misinterpreted.
  @override
  String render(Context _) => text
      // dot after a number in the beginning of the string is a list item
      .replaceAllMapped(_orderedListItem, (m) => '${m[1]}\\. ')
      // Special markdown chars: emphasis, strikethrough, table cell, links
      .replaceAllMapped(_specialChars, (m) => '\\${m[0]}')
      // + and - in the beginning of the string is a list item
      .replaceAllMapped(_unorderedListItem, (m) => '\\${m[0]}')
      // # in the beginning of the string is a header
      .replaceAllMapped(_header, (m) => '\\${m[0]}');
}
