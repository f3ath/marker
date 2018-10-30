import 'package:markdown/markdown.dart';
import 'package:marker/marker.dart';

/// The [Visitor] walks over the list of nodes and renders markdown text
/// with the given [textPrinter] and [elementPrinters].
class Visitor implements NodeVisitor, Context {
  Visitor(this.textPrinter, this.elementPrinters, this.inlineImages,
      this.inlineLinks);

  final TextPrinter textPrinter;
  final Map<String, ElementPrinter> elementPrinters;
  final bool inlineImages;
  final bool inlineLinks;

  final List<StringBuffer> _buff = [StringBuffer()];
  final List<Element> _path = [];
  final List<String> _delayed = [];

  @override
  void visitText(Text text) =>
      _buff.last.write(textPrinter(text.textContent, this));

  @override
  void visitElementAfter(Element element) {
    final tag = element.tag;
    String text = _buff.last.toString();
    _buff.removeLast();
    if (elementPrinters.containsKey(tag)) {
      text = elementPrinters[tag](element.attributes, text, this);
    }
    _buff.last.write(text);
    _path.removeLast();
  }

  @override
  bool visitElementBefore(Element element) {
    _path.add(element);
    _buff.add(StringBuffer());
    return true;
  }

  List<Element> get path => List.unmodifiable(_path);

  writeDelayed(String text) => _delayed.add(text);

  void dumpDelayed() => _delayed.forEach(_buff.last.write);

  String get markdown => _buff.last.toString();
}
