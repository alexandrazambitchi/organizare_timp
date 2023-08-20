class Group {
  String? id;
  String name;
  String leader;
  String? description;

  Group({
    this.id,
    required this.name,
    required this.leader, 
    this.description,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'leader': leader,
    };
  }

}