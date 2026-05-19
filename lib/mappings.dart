import 'package:deutschlich_besser/models/enums.dart';


Map<Case, Map<String, String>> definiteToIndefiniteMapping = {
  Case.Akkusativ: {
    "der": "einen",
    "die": "eine",
    "das": "ein"
  },
  Case.Dativ: {
    "der": "einem",
    "die": "einer",
    "das": "einem"
  },
};

Map<Case, Map<String, String>> definiteToDefiniteMapping = {
  Case.Akkusativ: {
    "der": "den",
    "die": "die",
    "das": "das"
  },
  Case.Dativ: {
    "der": "dem",
    "die": "der",
    "das": "dem"
  },
};


Map<Case, Map<String, String>> definiteToDefiniteAdjectiveMapping = {
  Case.Akkusativ: {
    "der": "en",
    "die": "e",
    "das": "e"
  },
  Case.Dativ: {
    "der": "en",
    "die": "en",
    "das": "en"
  },
};


Map<Case, Map<String, String>> definiteToIndefiniteAdjectiveMapping = {
  Case.Akkusativ: {
    "der": "en",
    "die": "e",
    "das": "es"
  },
  Case.Dativ: {
    "der": "en",
    "die": "en",
    "das": "en"
  },
};