// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verb _$VerbFromJson(Map<String, dynamic> json) => Verb(
  json['word'] as String,
  json['translation'] as String,
  json['separable'] as String,
  json['reflexiv'] as bool,
  json['praeteritum'] as String,
  json['perfect'] as String,
  json['preposition'] as String,
  $enumDecode(_$CaseEnumMap, json['case']),
  person: json['person'] as bool? ?? false,
  someoneElse: json['someone_else'] as String? ?? "",
);

Map<String, dynamic> _$VerbToJson(Verb instance) => <String, dynamic>{
  'word': instance.word,
  'translation': instance.translation,
  'separable': instance.separable,
  'reflexiv': instance.reflexiv,
  'praeteritum': instance.praeteritum,
  'perfect': instance.perfect,
  'preposition': instance.preposition,
  'case': _$CaseEnumMap[instance.caseOfSpeech]!,
  'person': instance.person,
  'someone_else': instance.someoneElse,
};

const _$CaseEnumMap = {
  Case.Akkusativ: 'Akkusativ',
  Case.Dativ: 'Dativ',
  Case.Genitiv: 'Genitiv',
};
