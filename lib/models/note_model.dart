class Note {
  String title;
  String content;
  String author;

  Note({required this.title, required this.content, required this.author});

  get id => null;

  static Object? fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] as String,
      content: map['content'] as String,
      author: map['author'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
    };
  }
}