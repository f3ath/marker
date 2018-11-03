import 'package:marker/ast.dart';
import 'package:marker/src/flavors/standard.dart';

final Map<String, NodeConstructor> standard = {
  '_': () => Node(),
  'h1': () => Header(1),
  'h2': () => Header(2),
  'h3': () => Header(3),
  'h4': () => Header(4),
  'h5': () => Header(5),
  'h6': () => Header(6),
  'p': () => Paragraph(),
  'br': () => LineBreak(),
  'blockquote': () => BlockQuote(),
  'ol': () => OrderedList(),
  'ul': () => UnorderedList(),
  'li': () => ListItem(),
  'code': () => Code(),
  'pre': () => Pre(),
  'hr': () => HorizontalRule(),
  'em': () => Emphasis('*'),
  'strong': () => Emphasis('**'),
  'a': () => Link(),
  'img': () => Image(),
};
