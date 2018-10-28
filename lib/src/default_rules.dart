import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';

class DefaultRules implements Rules {
  String _listMarker;
  final List<Element> _elements = [];

  final Map<String, _Decorator> _closers = {
    'em': (text, attr, c) => '*${text}*',
    'strong': (text, attr, c) => '**${text}**',
    'p': (text, attr, c) => '${text}\n\n',
    'h1': (text, attr, c) => '# ${text}\n',
    'h2': (text, attr, c) => '## ${text}\n',
    'h3': (text, attr, c) => '### ${text}\n',
    'h4': (text, attr, c) => '#### ${text}\n',
    'h5': (text, attr, c) => '##### ${text}\n',
    'h6': (text, attr, c) => '###### ${text}\n',
    'ol': (text, attr, c) => '${text}\n',
    'ul': (text, attr, c) => '${text}\n',
    'br': (text, attr, c) => '  \n',
    'hr': (text, attr, c) => '***\n',
    'img': (text, attr, c) {
      var title = '';
      if (attr.containsKey('title')) {
        title = ' "${attr['title']}"';
      }
      return '![${attr['alt']}](${attr['src']}${title})';
    },
    'a': (text, attr, c) {
      String title = '';
      if (attr.containsKey('title')) {
        title = ' "${attr['title']}"';
      }
      return '[$text](${attr['href']}$title)';
    },
    'blockquote': (text, attr, c) {
      final prefix = '> ';
      return prefix + text.trim().replaceAll('\n', '\n${prefix}') + '\n\n';
    },
    'code': (text, attr, c) {
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

  @override
  void onText(String text, Context context) => context.write(text);

  @override
  void onExit(Element element, String text, Context context) {
    final tag = element.tag;
    if (_closers.containsKey(tag)) {
      context.write(_closers[tag](text, element.attributes, context));
    } else if (tag == 'li') {
      context.write('${_listMarker} ${text}\n');
    } else {
      context.write(text);
    }
    _elements.removeLast();
  }

  @override
  void onEnter(Element element, Context context) {
    _elements.add(element);
    final tag = element.tag;
    if (tag == 'ol') {
      _listMarker = '1.';
    } else if (tag == 'ul') {
      _listMarker = '-';
    }
  }
}

typedef String _Decorator(String text, Map<String, String> attr, Context c);
