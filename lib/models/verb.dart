import 'package:deutschlich_besser/models/enums.dart';
import 'package:deutschlich_besser/models/word.dart';
import 'package:json_annotation/json_annotation.dart';


part 'verb.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class Verb extends Word {
  String separable;
  bool reflexiv;
  String praeteritum;
  String perfect;

  String preposition;
  @JsonKey(name: 'case')
  Case caseOfSpeech;
  bool person;
  String someoneElse;

  Verb(super.word, super.translation, this.separable, this.reflexiv, this.praeteritum, this.perfect, this.preposition, this.caseOfSpeech, {this.person = false, this.someoneElse = ""});

  get root => word.replaceFirst(separable, "").trim();



  factory Verb.fromJson(Map<String, dynamic> json) => _$VerbFromJson(json);

  Map<String, dynamic> toJson() => _$VerbToJson(this);
}
