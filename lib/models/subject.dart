


enum Person {
  First,
  Second,
  Third
}

enum Number {
  Singular,
  Plural
}

class Subject {
  var personalMapping = {
    Number.Singular: {
      Person.First: "ich",
      Person.Second: "du",
      Person.Third: "er/sie/es",
    },
    Number.Plural: {
      Person.First: "wir",
      Person.Second: "ihr",
      Person.Third: "sie",
    },
  };

  var reflexiveMapping = {
    Number.Singular: {
      Person.First: "mich",
      Person.Second: "dich",
      Person.Third: "sich",
    },
    Number.Plural: {
      Person.First: "uns",
      Person.Second: "euch",
      Person.Third: "sich",
    },
  };

  Person person;
  Number number;

  String get personal => personalMapping[number]![person]!;
  String get reflexive => reflexiveMapping[number]![person]!;
  String get possessive => personalMapping[number]![person]!;

  Subject({required this.person, required this.number});
}

