class GuestBookMessage {
  GuestBookMessage({
    required this.uid,
    required this.time,
    required this.name,
    required this.message,
    required this.id,
  });

  final String name;
  final String message;
  final DateTime time;
  final String uid;
  final String id;
}
