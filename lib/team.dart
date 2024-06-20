class TeamFields {
  static const List<String> values = [
    id,
    name,
    year,
    dateChamp
  ];
  static const String tableName = 'team';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String year = 'year';
  static const String dateChamp= 'dateChamp';
 
}


class TeamModel {
   int? id;
  final String name;
  final String year;
  final DateTime? dateChamp;

  TeamModel({
    this.id,
    required this.name,
    required this.year,
    this.dateChamp,
  });
   Map<String, Object?> toJson() => {
        TeamFields.id: id,
        TeamFields.name: name,
        TeamFields.year: year,
        TeamFields.dateChamp: dateChamp?.toIso8601String(),
      };


  factory TeamModel.fromJson(Map<String, Object?> json) => TeamModel(
        id: json[TeamFields.id] as int?,
        name: json[TeamFields.name] as String,
        year: json[TeamFields.year] as String,
        dateChamp: 
            DateTime.tryParse(json[TeamFields.dateChamp] as String? ?? ''),
      );
      
  TeamModel copy({
    int? id,
    int? number,
    String? title,
    String? content,
    bool? isFavorite,
    DateTime? createdTime,
    DateTime? deadline,
  }) =>
      TeamModel(
        id: id ?? this.id,
        name: name,
        year: year,
        dateChamp: dateChamp ?? dateChamp,

      );
}