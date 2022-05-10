import 'package:marker/src/ast/context.dart';

/// The base interface for the rendering tree nodes.
abstract class Renderable {
  /// Renders the node into markdown according to [context].
  String render(Context context);
}
