import '../../domain/entities/source_entity.dart';

class SourceModel extends SourceEntity {
  const SourceModel({super.id, required super.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'] as String?,
      name: (json['name'] as String?) ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}