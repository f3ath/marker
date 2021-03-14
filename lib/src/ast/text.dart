
import 'package:marker/src/ast/context.dart';
import 'package:marker/src/ast/printable.dart';

class Text implements Printable {
  Text(this.text);

  final String text;

  /// Escapes common markdown special characters if those could be
  /// misinterpreted.
  @override
  String print(Context context) => text
  // dot after a number in the beginning of the string is a list item
      .replaceAllMapped(RegExp(r'^(\d+)\. '), (m) => '${m[1]}\\. ')
  // Special markdown chars: emphasis, strikethrough, table cell, links
      .replaceAllMapped(RegExp(r'[*_~|\[\]]'), (m) => '\\${m[0]}')
  // + and - in the beginning of the string is a list item
      .replaceAllMapped(RegExp(r'^[+-] '), (m) => '\\${m[0]}')
  // # in the beginning of the string is a header
      .replaceAllMapped(RegExp(r'^#'), (m) => '\\${m[0]}');
}
