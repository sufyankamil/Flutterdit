class Community {
  final String id;
  final String name;
  final String description;
  final String banner;
  final String avatar;
  final List<String> moderators;
  final List<String> members;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.banner,
    required this.avatar,
    required this.moderators,
    required this.members,
  });

  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? banner,
    String? avatar,
    List<String>? moderators,
    List<String>? members,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      moderators: moderators ?? this.moderators,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'banner': banner,
      'avatar': avatar,
      'moderators': moderators,
      'members': members,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      banner: map['banner'],
      avatar: map['avatar'],
      moderators: List<String>.from(map['moderators']),
      members: List<String>.from(map['members']),
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name, description: $description, banner: $banner, avatar: $avatar, moderators: $moderators, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.banner == banner &&
        other.avatar == avatar &&
        other.moderators == moderators &&
        other.members == members;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        moderators.hashCode ^
        members.hashCode;
  }
}
