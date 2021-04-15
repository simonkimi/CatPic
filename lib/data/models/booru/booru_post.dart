import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

enum PostRating { SAFE, EXPLICIT, QUESTIONABLE }

String getRatingText(BuildContext context, PostRating rating) {
  switch (rating) {
    case PostRating.SAFE:
      return I18n.of(context).safe;
    case PostRating.EXPLICIT:
      return I18n.of(context).explicit;
    case PostRating.QUESTIONABLE:
      return I18n.of(context).questionable;
  }
}

class BooruPost {
  BooruPost(
      {required this.id,
      required this.md5,
      required this.creatorId,
      required this.imgURL,
      required this.previewURL,
      required this.sampleURL,
      required this.width,
      required this.height,
      required this.sampleWidth,
      required this.sampleHeight,
      required this.previewWidth,
      required this.previewHeight,
      required this.rating,
      required this.status,
      required this.tags,
      required this.source,
      required this.createTime,
      required this.score});

  final String id;
  final String creatorId;
  final String createTime;
  final String md5;

  final String imgURL;
  final String previewURL;
  final String sampleURL;

  final int width;
  final int height;
  final int sampleWidth;
  final int sampleHeight;
  final int previewWidth;
  final int previewHeight;

  final PostRating rating;
  final String status;
  final Map<String, List<String>> tags;
  final String source;
  final String score;
}
