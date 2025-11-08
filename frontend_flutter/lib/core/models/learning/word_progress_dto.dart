class WordProgressDTO {
  final int dictionaryPersonalId;
  final bool wasCorrect;

  WordProgressDTO({
    required this.dictionaryPersonalId,
    required this.wasCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'dictionaryPersonalId': dictionaryPersonalId,
      'wasCorrect': wasCorrect,
    };
  }
}