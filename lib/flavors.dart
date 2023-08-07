import 'package:marker/ast.dart';
import 'package:marker/src/flavors/changelog.dart';
import 'package:marker/src/flavors/original.dart';

/// The original flavor.
/// See https://daringfireball.net/projects/markdown/syntax
final original = <String, Node Function()>{
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

/// The changelog flavor.
final changelog = <String, Node Function()>{
  ...original,
  'h2': () => Release(), // Release header is special
};
