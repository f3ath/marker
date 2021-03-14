import 'package:marker/src/ast/context.dart';

/// The base interface for the rendering tree nodes.
abstract class Printable {
  /// Renders the node into markdown according to [context].
  String print(Context context);
}
