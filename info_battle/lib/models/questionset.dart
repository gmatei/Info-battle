// @dart=2.9

import 'package:info_battle/models/question.dart';

class QuestionSet {
  final String qsetId;
  final String addedBy;
  final String title;
  final String description;

  const QuestionSet({
    this.qsetId,
    this.addedBy,
    this.title,
    this.description,
  });
}
