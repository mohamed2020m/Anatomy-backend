class Favourite {
  final String id;
  final int studentId;
  final int threeDObjectId;

  Favourite({
    required this.id,
    required this.studentId,
    required this.threeDObjectId,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['id'].toString(),
      studentId: json['studentId'] as int,
      threeDObjectId: json['threeDObjectId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'threeDObjectId': threeDObjectId,
    };
  }
}
