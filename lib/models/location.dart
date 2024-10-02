class Location {
  String? 
    id;
  final String name;
  final int plantCount;

  Location({
    required this.name,
  }) : plantCount = 0;

  Location._({
    required this.id,
    required this.name,
    required this.plantCount,
  });

  factory Location.fromMap(Map<String, dynamic> map, String? id){
    return Location._(
      id: id, 
      name: map['name'],
      plantCount: map['plantCount'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id, 
      'name': name,
      'plantCount': plantCount,
    };
  }
}