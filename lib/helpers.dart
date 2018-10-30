String escape(String s) => s.replaceAllMapped(
    RegExp(r'[`\\\[\]\*\{\}\(\)\+\_#.!-]'), (m) => '\\${m[0]}');

/// Generates a unique id
int id() => ++_id;
int _id = 0;
