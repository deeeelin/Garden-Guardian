class DrinkWater {
  DrinkWater({
    required this.water,
  });

  DrinkWater._({
    required this.id,
    required this.water,
  });

  String? id;
  final int water;

  factory DrinkWater.fromMap(Map<String, dynamic> map, String? id) {
    return DrinkWater._(
      id: id,
      water: map['water'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'water': water,
    };
  }
}