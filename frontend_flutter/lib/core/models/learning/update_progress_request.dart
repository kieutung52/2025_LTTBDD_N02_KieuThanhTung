import 'word_progress_dto.dart';

class UpdateProgressRequest {
  final List<WordProgressDTO> progressList;

  UpdateProgressRequest({required this.progressList});

  Map<String, dynamic> toJson() {
    return {
      'progressList': progressList.map((e) => e.toJson()).toList(),
    };
  }
}