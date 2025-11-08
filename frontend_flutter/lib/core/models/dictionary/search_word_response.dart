import '../enums/vocab_level.dart';
import 'vocab_detail_dto.dart';

class SearchWordResponse {
  final String vocabulary;
  final VocabularyLevel level;
  final String? transcriptionUk;
  final String? transcriptionUs;
  final List<VocabDetailDTO> details;

  SearchWordResponse({
    required this.vocabulary,
    required this.level,
    this.transcriptionUk,
    this.transcriptionUs,
    required this.details,
  });

  factory SearchWordResponse.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List;
    List<VocabDetailDTO> details =
        detailsList.map((i) => VocabDetailDTO.fromJson(i)).toList();

    return SearchWordResponse(
      vocabulary: json['vocabulary'] as String,
      level: vocabLevelFromString(json['level']),
      transcriptionUk: json['transcriptionUk'] as String?,
      transcriptionUs: json['transcriptionUs'] as String?,
      details: details,
    );
  }
}