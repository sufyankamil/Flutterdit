class Comments {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String userName;
  final String profilePic;
  final String? userId;
  Comments({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.userName,
    required this.profilePic,
    this.userId,
  });

  Comments copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? userName,
    String? profilePic,
    String? userId,
  }) {
    return Comments(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'userName': userName,
      'profilePic': profilePic,
      'userId': userId,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      userName: map['userName'] as String,
      profilePic: map['profilePic'] as String,
      userId: map['userId'] as String?,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, userName: $userName, profilePic: $profilePic) userId: $userId';
  }

  @override
  bool operator ==(covariant Comments other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.userName == userName &&
        other.userId == userId &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        userName.hashCode ^
        userId.hashCode ^
        profilePic.hashCode;
  }
}
