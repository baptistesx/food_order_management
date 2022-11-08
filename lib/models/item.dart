class Item {
  final String? id;
  final String? userId;
  final String? name;

  const Item({
    this.id,
    this.userId,
    this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
