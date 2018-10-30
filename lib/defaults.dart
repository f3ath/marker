import 'package:marker/helpers.dart' as md;
import 'package:marker/marker.dart';

/// The default text handler.
String textHandler(String text, Context ctx) {
  if (ctx.path.last != null && ctx.path.last.tag == 'code') {
    return text;
  }
  return md.escape(text);
}

/// The default element-to-handler map.
final Map<String, ElementPrinter> elementHandlers = Map.unmodifiable(_handlers);
final Map<String, ElementPrinter> _handlers = {
  'em': (attr, text, ctx) => '*${text}*',
  'strong': (attr, text, ctx) => '**${text}**',
  'p': (attr, text, ctx) => '${text}\n\n',
  'h1': (attr, text, ctx) => '# ${text}\n',
  'h2': (attr, text, ctx) => '## ${text}\n',
  'h3': (attr, text, ctx) => '### ${text}\n',
  'h4': (attr, text, ctx) => '#### ${text}\n',
  'h5': (attr, text, ctx) => '##### ${text}\n',
  'h6': (attr, text, ctx) => '###### ${text}\n',
  'ol': (attr, text, ctx) => '${text}\n',
  'ul': (attr, text, ctx) => '${text}\n',
  'li': (attr, text, ctx) {
    final isOrdered = ctx.path[ctx.path.length - 2].tag == 'ol';
    return '${isOrdered ? '1.' : '-'} ${text}\n';
  },
  'br': (attr, text, ctx) => '  \n',
  'hr': (attr, text, ctx) => '***\n',
  'img': (attr, text, ctx) {
    var title = '';
    if (attr.containsKey('title')) {
      title = ' "${attr['title']}"';
    }
    return '![${attr['alt']}](${attr['src']}${title})';
  },
  'a': (attr, text, ctx) {
    String title = '';
    if (attr.containsKey('title')) {
      title = ' "${attr['title']}"';
    }
    return '[${text}](${attr['href']}$title)';
  },
  'blockquote': (attr, text, ctx) {
    final prefix = '> ';
    return prefix + text.trim().replaceAll('\n', '\n${prefix}') + '\n\n';
  },
  'code': (attr, text, ctx) {
    if (text.contains('\n')) {
      String lang = '';
      final prefix = 'language-';
      if (attr.containsKey('class') && attr['class'].startsWith(prefix)) {
        lang = attr['class'].substring(prefix.length);
      }
      return '\n```${lang}\n${text}```\n';
    }
    return '```${text}```';
  }
};