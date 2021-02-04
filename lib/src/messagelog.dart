import 'package:meta/meta.dart';

import 'package:malison/malison.dart';

class Message {
  final String _plainText;
  final Color _fg;
  int count = 1;

  Message(this._plainText, this._fg);

  String get plainText => _plainText;
  Color get fg => _fg;

  String get fullText {
    if (count > 1) {
      return '$_plainText (x$count)';
    }
    return _plainText;
  }

  List wrap(int width) {
    var lines = [];
    if (fullText.length <= width) {
      lines.add(fullText);
    } else {
      var words = fullText.split(' ').reversed.toList();
      var line = '';
      var nextWord = '';
      while (words.isNotEmpty) {
        nextWord = words.removeLast();
        if ((line + ' ' + nextWord).length < width) {
          if (line.isNotEmpty) {
            line += ' ';
          }
          line += nextWord;
        } else {
          lines.add(line);
          line = nextWord;
        }
        if (words.isEmpty && line.isNotEmpty) {
          lines.add(line);
        }
      }
    }
    return lines;
  }
}

class MessageLog {
  List messages = [];

  void addMessage(
      {@required String text, Color fg = Color.white, bool stack = true}) {
    if (stack && messages.isNotEmpty && text == messages.last.plainText) {
      messages.last.count += 1;
    } else {
      messages.add(Message(text, fg));
    }
  }

  void render(Terminal terminal, int x, int y, int width, int height) {
    renderMessages(terminal, x, y, width, height, messages);
  }

  void renderMessages(
      Terminal terminal, int x, int y, int width, int height, List messages) {
    var yOffset = height - 1;

    for (var message in messages.reversed) {
      for (var line in message.wrap(width).reversed) {
        terminal.writeAt(x, y + yOffset, line, message.fg);
        yOffset -= 1;
        if (yOffset < 0) {
          return;
        }
      }
    }
  }
}
