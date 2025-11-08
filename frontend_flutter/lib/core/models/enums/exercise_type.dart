enum ExerciseType {
  listening,
  reading,
  writing,
  speaking,
  grammar,
  vocabulary,
  flashcard,
  matching
}

ExerciseType exerciseTypeFromString(String? type) {
  return ExerciseType.values.firstWhere(
    (e) => e.name == type,
    orElse: () => ExerciseType.vocabulary,
  );
}