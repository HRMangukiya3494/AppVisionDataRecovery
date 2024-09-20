enum FileType {
  image,
  video,
  audio,
  document,
}

class FileModel {
  final int id;
  final String name;
  final String path;
  final FileType type;

  FileModel({required this.id, required this.name, required this.path, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type.index,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      type: FileType.values[map['type']],
    );
  }
}
