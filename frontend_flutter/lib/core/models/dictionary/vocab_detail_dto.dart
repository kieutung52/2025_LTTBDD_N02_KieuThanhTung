import '../enums/vocab_type.dart';

class VocabDetailDTO {
  final VocabularyType vocabType;
  final String meaning;
  final String? explanation;
  final String? exampleSentence;

  VocabDetailDTO({
    required this.vocabType,
    required this.meaning,
    this.explanation,
    this.exampleSentence,
  });

  factory VocabDetailDTO.fromJson(Map<String, dynamic> json) {
    return VocabDetailDTO(
      vocabType: vocabTypeFromString(json['vocabType'] as String?),
      meaning: json['meaning'] as String,
      explanation: json['explanation'] as String?,
      exampleSentence: json['exampleSentence'] as String?,
    );
  }
}