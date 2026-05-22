import 'package:equatable/equatable.dart';

class SourceEntity extends Equatable {
  final String? id;
  final String name;
  const SourceEntity({this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}