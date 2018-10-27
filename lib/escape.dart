String escape(String s) => s.replaceAllMapped(
    RegExp(r'[`\\\[\]\*\{\}\(\)\+\_#.!-]'), (m) => '\\${m[0]}');