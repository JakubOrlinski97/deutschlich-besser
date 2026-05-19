// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noun.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noun _$NounFromJson(Map<String, dynamic> json) => Noun(
  json['word'] as String,
  json['translation'] as String,
  json['plural'] as String,
);

Map<String, dynamic> _$NounToJson(Noun instance) => <String, dynamic>{
  'word': instance.word,
  'translation': instance.translation,
  'plural': instance.plural,
};
