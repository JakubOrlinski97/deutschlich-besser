import 'package:deutschlich_besser/mappings.dart';
import 'package:deutschlich_besser/models/enums.dart';
import 'package:deutschlich_besser/models/word.dart';
import 'package:json_annotation/json_annotation.dart';


part 'noun.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Noun extends Word {
  String plural;

  Noun(super.word, super.translation, this.plural);

  factory Noun.fromJson(Map<String, dynamic> json) => _$NounFromJson(json);

  Map<String, dynamic> toJson() => _$NounToJson(this);


  String get article => word.substring(0, 3);

  String get root => word.substring(3).trim();

  String getAdjectiveEnding(
      Case caseOfSpeech,
      bool isDefinite,
      ) {
    if (isDefinite) {
      return definiteToDefiniteAdjectiveMapping[caseOfSpeech]![article]!;
    } else {
      return definiteToIndefiniteAdjectiveMapping[caseOfSpeech]![article]!;
    }
  }

  String adjustArticleToCase(
      Case caseOfSpeech,
      bool isDefinite,
      ) {
    if (isDefinite) {
      return definiteToIndefiniteMapping[caseOfSpeech]![article]!;
    } else {
      return definiteToDefiniteMapping[caseOfSpeech]![article]!;
    }
  }
}
