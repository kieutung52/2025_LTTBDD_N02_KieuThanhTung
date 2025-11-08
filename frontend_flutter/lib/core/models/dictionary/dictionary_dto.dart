import 'package:frontend_flutter/core/models/dictionary/vocab_detail_dto.dart';
import '../enums/vocab_level.dart';

class DictionaryDTO {
  final int id;
  final String vocabulary;
  final VocabularyLevel level;
  final String? transcriptionUk;
  final String? transcriptionUs;
  final String? audioUrlUk;
  final String? audioUrlUs;
  final List<VocabDetailDTO> details;

  DictionaryDTO({
    required this.id,
    required this.vocabulary,
    required this.level,
    required this.details,
    this.transcriptionUk,
    this.transcriptionUs,
    this.audioUrlUk,
    this.audioUrlUs,
  });

  factory DictionaryDTO.fromJson(Map<String, dynamic> json) {
    List<VocabDetailDTO> detailsList = [];
    if (json['details'] != null) {
      detailsList = (json['details'] as List)
          .map((i) => VocabDetailDTO.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return DictionaryDTO(
      id: json['id'] as int,
      vocabulary: json['vocabulary'] as String,
      level: vocabLevelFromString(json['level'].toString().toLowerCase()),
      transcriptionUk: json['transcriptionUk'] as String?,
      transcriptionUs: json['transcriptionUs'] as String?,
      audioUrlUk: json['audioUrlUk'] as String?,
      audioUrlUs: json['audioUrlUs'] as String?,
      details: detailsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabulary': vocabulary,
      'level': level.name,
      'transcriptionUk': transcriptionUk,
      'transcriptionUs': transcriptionUs,
      'audioUrlUk': audioUrlUk,
      'audioUrlUs': audioUrlUs,
      'details': details.map((d) => d.toJson()).toList(),
    };
  }
}

extension VocabDetailDTOExtension on VocabDetailDTO {
  Map<String, dynamic> toJson() {
    return {
      'vocabType': vocabType.name,
      'meaning': meaning,
      'explanation': explanation,
      'exampleSentence': exampleSentence,
    };
  }
}