import 'dart:typed_data';

class FootballField {
  final String id;
  final String name;
  final int ratingCount;
  final double averageRating;
  final Uint8List imageBuffer;

  FootballField({
    required this.id,
    required this.name,
    required this.ratingCount,
    required this.averageRating,
    required this.imageBuffer,
  });

  factory FootballField.fromJson(Map<String, dynamic> json) {
    return FootballField(
      id: json['id'],
      name: json['name'],
      ratingCount: json['rating_count'],
      averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
      imageBuffer: Uint8List.fromList(List<int>.from(json['image'])), // assuming image is sent as binary array
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating_count': ratingCount,
      'average_rating': averageRating.toString(),
      'image': imageBuffer, // it will be sent as binary array
    };
  }
}
