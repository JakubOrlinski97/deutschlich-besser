


import 'package:deutschlich_besser/models/adjective.dart';
import 'package:deutschlich_besser/models/enums.dart';
import 'package:deutschlich_besser/models/noun.dart';
import 'package:deutschlich_besser/models/subject.dart';
import 'package:deutschlich_besser/models/verb.dart';

class Exercise {
  Subject subject;
  Verb verb;
  Adjective adjective;
  Noun noun;
  String splitSuffix;
  String correctArticle;
  String correctEnding;
  Tense tense;

  Exercise({
    required this.subject,
    required this.verb,
    required this.adjective,
    required this.noun,
    required this.splitSuffix,
    required this.correctArticle,
    required this.correctEnding,
    required this.tense
  });

  static Exercise Empty() {
    return new Exercise(
      subject: Subject(person: Person.First, number: Number.Plural),
      verb: Verb("", "", "", false, "", "", "", Case.Akkusativ),
      adjective: Adjective("", ""),
      noun: Noun("", "", ""),
      splitSuffix: "",
      correctArticle: "",
      correctEnding: "",
      tense: Tense.Present
    );
  }
}