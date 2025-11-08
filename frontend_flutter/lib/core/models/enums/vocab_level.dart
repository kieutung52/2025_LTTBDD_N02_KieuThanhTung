enum VocabularyLevel {
  a1, a2, b1, b2, c1, c2
}

VocabularyLevel vocabLevelFromString(String? level) {
  return VocabularyLevel.values.firstWhere(
    (e) => e.name == level,
    orElse: () => VocabularyLevel.a1,
  );
}