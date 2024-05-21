import 'package:equatable/equatable.dart';

class RecordingModel extends Equatable{
  final String name;
  final DateTime createAt;
  final String path;

  const RecordingModel({required this.name, required this.createAt, required this.path});

  @override
  List<Object?> get props => [name,createAt,path];
}