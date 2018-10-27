import 'package:markdown_printer/escape.dart' as md;
import 'package:test/test.dart';

void main() {
  test('Escape', () {
    expect(md.escape(r'escape: \ ` * _ { } [ ] ( ) # + - . !'),
        r'escape: \\ \` \* \_ \{ \} \[ \] \( \) \# \+ \- \. \!');
  });
}
