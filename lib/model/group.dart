class Group {
  String? id;
  String name;
  String leader;
  String? description;
  List<String> members;

  Group(
      {this.id,
      required this.name,
      required this.leader,
      this.description,
      required this.members});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leader': leader,
      'members': members
    };
  }
}
