import 'package:marker/ast.dart';
import 'package:marker/src/flavors/changelog.dart' as chlg;
import 'package:marker/src/flavors/original.dart' as orig;

/// The original flavor.
/// See https://daringfireball.net/projects/markdown/syntax
final Map<String, NodeConstructor> original = {
  '_': () => Node(),
  'h1': () => orig.Header(1),
  'h2': () => orig.Header(2),
  'h3': () => orig.Header(3),
  'h4': () => orig.Header(4),
  'h5': () => orig.Header(5),
  'h6': () => orig.Header(6),
  'p': () => orig.Paragraph(),
  'br': () => orig.LineBreak(),
  'blockquote': () => orig.BlockQuote(),
  'ol': () => orig.OrderedList(),
  'ul': () => orig.UnorderedList(),
  'li': () => orig.ListItem(),
  'code': () => orig.Code(),
  'pre': () => orig.Pre(),
  'hr': () => orig.HorizontalRule(),
  'em': () => orig.Emphasis('*'),
  'strong': () => orig.Emphasis('**'),
  'a': () => orig.Link(),
  'img': () => orig.Image(),
};

/// The changelog flavor.
final Map<String, NodeConstructor> changelog = {
  '_': () => Node(),
  'h1': () => orig.Header(1),
  'h2': () => chlg.Release(), // Release header is special
  'h3': () => orig.Header(3),
  'h4': () => orig.Header(4),
  'h5': () => orig.Header(5),
  'h6': () => orig.Header(6),
  'p': () => orig.Paragraph(),
  'br': () => orig.LineBreak(),
  'blockquote': () => orig.BlockQuote(),
  'ol': () => orig.OrderedList(),
  'ul': () => orig.UnorderedList(),
  'li': () => orig.ListItem(),
  'code': () => orig.Code(),
  'pre': () => orig.Pre(),
  'hr': () => orig.HorizontalRule(),
  'em': () => orig.Emphasis('*'),
  'strong': () => orig.Emphasis('**'),
  'a': () => orig.Link(),
  'img': () => orig.Image(),
};
