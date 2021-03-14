/// Provides the rendering context.
class Context {
  Context(this.inlineImages, this.inlineLinks);

  /// Whether the images should be rendered inline (or as references)
  final bool inlineImages;

  /// Whether the links should be rendered inline (or as references)
  final bool inlineLinks;

  /// Accumulates references to images and links generated during rendering.
  /// When the rendering is done, these lines will be added to the bottom
  /// of the generated document.
  final List<String> references = [];
}
