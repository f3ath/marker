import 'package:markdown/markdown.dart';

class TreePrinter implements NodeVisitor {
  var level = 0;
  final _indent = '  ';

  @override
  bool visitElementBefore(Element element) {
    print('${_indent * level}${element.tag}${element.attributes}');
    level++;
    return true;
  }

  @override
  void visitElementAfter(Element element) {
    level--;
  }

  @override
  void visitText(Text text) {
    print('${_indent * level}Text: $text');
  }
}
