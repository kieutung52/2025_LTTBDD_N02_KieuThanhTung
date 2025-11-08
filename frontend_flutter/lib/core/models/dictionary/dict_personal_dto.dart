import 'dictionary_dto.dart';
import 'dart:convert';

class DictPersonalDTO {
  final int id;
  final DictionaryDTO dictionary;
  final int lookupCount;
  final int practiceCount;
  final int correctAnswerCount;
  final int incorrectAnswerCount;
  final DateTime lastReviewDate;
  final DateTime nextReviewDate;

  DictPersonalDTO({
    required this.id,
    required this.dictionary,
    required this.lookupCount,
    required this.practiceCount,
    required this.correctAnswerCount,
    required this.incorrectAnswerCount,
    required this.lastReviewDate,
    required this.nextReviewDate,
  });

  factory DictPersonalDTO.fromJson(Map<String, dynamic> json) {
    return DictPersonalDTO(
      id: json['id'] as int,
      dictionary: DictionaryDTO.fromJson(json['dictionary'] as Map<String, dynamic>),
      lookupCount: json['lookupCount'] as int,
      practiceCount: json['practiceCount'] as int,
      correctAnswerCount: json['correctAnswerCount'] as int,
      incorrectAnswerCount: json['incorrectAnswerCount'] as int,
      lastReviewDate: DateTime.parse(json['lastReviewDate'] as String),
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dictionary': dictionary.toJson(),
      'lookupCount': lookupCount,
      'practiceCount': practiceCount,
      'correctAnswerCount': correctAnswerCount,
      'incorrectAnswerCount': incorrectAnswerCount,
      'lastReviewDate': lastReviewDate.toIso8601String().split('T').first,
      'nextReviewDate': nextReviewDate.toIso8601String().split('T').first,
    };
  }

  static String encodeList(List<DictPersonalDTO> lessons) {
    return jsonEncode(lessons.map((lesson) => lesson.toJson()).toList());
  }

  static List<DictPersonalDTO> decodeList(String lessonsJson) {
    final List<dynamic> decodedList = jsonDecode(lessonsJson);
    return decodedList.map((item) => DictPersonalDTO.fromJson(item)).toList();
  }
}