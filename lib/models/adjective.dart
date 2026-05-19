import 'package:deutschlich_besser/models/word.dart';
import 'package:json_annotation/json_annotation.dart';


part 'adjective.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Adjective extends Word {

  Adjective(super.word, super.translation);

  factory Adjective.fromJson(Map<String, dynamic> json) => _$AdjectiveFromJson(json);

  Map<String, dynamic> toJson() => _$AdjectiveToJson(this);
}
