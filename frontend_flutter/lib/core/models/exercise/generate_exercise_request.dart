class GenerateExerciseRequest {
  final List<int> dictionaryIds;

  GenerateExerciseRequest({required this.dictionaryIds});

  Map<String, dynamic> toJson() {
    return {
      'dictionaryIds': dictionaryIds,
    };
  }
}