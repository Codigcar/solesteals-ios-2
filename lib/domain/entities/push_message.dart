class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final String path;
  final String? imageUrl;

  PushMessage({
    required this.messageId, 
    required this.title,
    required this.body,
    required this.path,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''
    PushMessage ****
      id: $messageId
      title: $title
      body: $body
      path: $path
      imageUrl: $imageUrl
    ''';
  }
}
