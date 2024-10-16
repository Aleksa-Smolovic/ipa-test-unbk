class Announcement {
  final int id;
  final String title;
  final String text;
  final String createdAt;
  final bool isHighlighted;

  Announcement(
    this.id,
    this.title,
    this.text,
    this.createdAt, {
    this.isHighlighted = false,
  });

  Announcement.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        text = json['text'] as String,
        createdAt = json['createdAt'] as String,
        isHighlighted = json['isHighlighted'] != null
            ? json['isHighlighted'] as bool
            : false;
}
