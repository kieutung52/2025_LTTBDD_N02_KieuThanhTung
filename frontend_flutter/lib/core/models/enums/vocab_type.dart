enum VocabularyType {
  noun,
  pronoun,
  verb,
  adjective,
  adverb,
  preposition,
  conjunction,
  interjection,
  dateminer,
  axuliaryVerb,
  modalVerb,
  particle,
  numeral,
  punctuation,
  phrasalVerb,
  nounPhrase,
  symbol,
  foreignWord,
  unknown
}

VocabularyType vocabTypeFromString(String? type) {
  final normalizedTypeStr = type?.toLowerCase().replaceAll('_', '');

  if (normalizedTypeStr == 'daterminer') {
    return VocabularyType.dateminer;
  }
  
  if (normalizedTypeStr == 'axuliaryverb') {
    return VocabularyType.axuliaryVerb;
  }

  return VocabularyType.values.firstWhere(
    (e) => e.name.toLowerCase() == normalizedTypeStr,
    orElse: () => VocabularyType.unknown,
  );
}