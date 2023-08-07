/// Provides the rendering context.
class Context {
  Context(this.inlineImages, this.inlineLinks, {this.lineBreak = '\n'});

  /// Returns the next generated id for images and links.
  String nextId() => 'id${_id++}';

  /// Whether the images should be rendered inline (or as references)
  final bool inlineImages;

  /// Whether the links should be rendered inline (or as references)
  final bool inlineLinks;

  /// Line break sequence
  final String lineBreak;

  /// Accumulates references to images and links generated during rendering.
  /// When the rendering is done, these lines will be added to the bottom
  /// of the generated document.
  final ref = <String, String>{};

  /// Internal id generator.
  int _id = 1;
}
