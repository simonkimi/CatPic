///
//  Generated code. Do not modify.
//  source: eh_gallery.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class GalleryBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GalleryBase', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  GalleryBase._() : super();
  factory GalleryBase({
    $core.String? gid,
    $core.String? token,
  }) {
    final _result = create();
    if (gid != null) {
      _result.gid = gid;
    }
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory GalleryBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GalleryBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GalleryBase clone() => GalleryBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GalleryBase copyWith(void Function(GalleryBase) updates) => super.copyWith((message) => updates(message as GalleryBase)) as GalleryBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryBase create() => GalleryBase._();
  GalleryBase createEmptyInstance() => create();
  static $pb.PbList<GalleryBase> createRepeated() => $pb.PbList<GalleryBase>();
  @$core.pragma('dart2js:noInline')
  static GalleryBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GalleryBase>(create);
  static GalleryBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class TagItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TagItem', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parent')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  TagItem._() : super();
  factory TagItem({
    $core.String? parent,
    $core.String? value,
  }) {
    final _result = create();
    if (parent != null) {
      _result.parent = parent;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory TagItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TagItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TagItem clone() => TagItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TagItem copyWith(void Function(TagItem) updates) => super.copyWith((message) => updates(message as TagItem)) as TagItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TagItem create() => TagItem._();
  TagItem createEmptyInstance() => create();
  static $pb.PbList<TagItem> createRepeated() => $pb.PbList<TagItem>();
  @$core.pragma('dart2js:noInline')
  static TagItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TagItem>(create);
  static TagItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parent => $_getSZ(0);
  @$pb.TagNumber(1)
  set parent($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class TagModels extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TagModels', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..pc<TagItem>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.PM, subBuilder: TagItem.create)
    ..hasRequiredFields = false
  ;

  TagModels._() : super();
  factory TagModels({
    $core.String? key,
    $core.Iterable<TagItem>? value,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value.addAll(value);
    }
    return _result;
  }
  factory TagModels.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TagModels.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TagModels clone() => TagModels()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TagModels copyWith(void Function(TagModels) updates) => super.copyWith((message) => updates(message as TagModels)) as TagModels; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TagModels create() => TagModels._();
  TagModels createEmptyInstance() => create();
  static $pb.PbList<TagModels> createRepeated() => $pb.PbList<TagModels>();
  @$core.pragma('dart2js:noInline')
  static TagModels getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TagModels>(create);
  static TagModels? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<TagItem> get value => $_getList(1);
}

class CommentModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CommentModel', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comment')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commentTime', protoName: 'commentTime')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'score', $pb.PbFieldType.O3)
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voteUser', protoName: 'voteUser')
    ..hasRequiredFields = false
  ;

  CommentModel._() : super();
  factory CommentModel({
    $core.String? username,
    $core.String? comment,
    $core.String? commentTime,
    $core.int? score,
    $core.Iterable<$core.String>? voteUser,
  }) {
    final _result = create();
    if (username != null) {
      _result.username = username;
    }
    if (comment != null) {
      _result.comment = comment;
    }
    if (commentTime != null) {
      _result.commentTime = commentTime;
    }
    if (score != null) {
      _result.score = score;
    }
    if (voteUser != null) {
      _result.voteUser.addAll(voteUser);
    }
    return _result;
  }
  factory CommentModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommentModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommentModel clone() => CommentModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommentModel copyWith(void Function(CommentModel) updates) => super.copyWith((message) => updates(message as CommentModel)) as CommentModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CommentModel create() => CommentModel._();
  CommentModel createEmptyInstance() => create();
  static $pb.PbList<CommentModel> createRepeated() => $pb.PbList<CommentModel>();
  @$core.pragma('dart2js:noInline')
  static CommentModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommentModel>(create);
  static CommentModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(2)
  set comment($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentTime($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommentTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get score => $_getIZ(3);
  @$pb.TagNumber(4)
  set score($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get voteUser => $_getList(4);
}

class PreviewImage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PreviewImage', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.O3)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'image')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'positioning', $pb.PbFieldType.O3)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'target')
    ..hasRequiredFields = false
  ;

  PreviewImage._() : super();
  factory PreviewImage({
    $core.int? height,
    $core.int? width,
    $core.String? image,
    $core.int? positioning,
    $core.String? target,
  }) {
    final _result = create();
    if (height != null) {
      _result.height = height;
    }
    if (width != null) {
      _result.width = width;
    }
    if (image != null) {
      _result.image = image;
    }
    if (positioning != null) {
      _result.positioning = positioning;
    }
    if (target != null) {
      _result.target = target;
    }
    return _result;
  }
  factory PreviewImage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewImage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewImage clone() => PreviewImage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewImage copyWith(void Function(PreviewImage) updates) => super.copyWith((message) => updates(message as PreviewImage)) as PreviewImage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PreviewImage create() => PreviewImage._();
  PreviewImage createEmptyInstance() => create();
  static $pb.PbList<PreviewImage> createRepeated() => $pb.PbList<PreviewImage>();
  @$core.pragma('dart2js:noInline')
  static PreviewImage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewImage>(create);
  static PreviewImage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get height => $_getIZ(0);
  @$pb.TagNumber(1)
  set height($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get positioning => $_getIZ(3);
  @$pb.TagNumber(4)
  set positioning($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPositioning() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositioning() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get target => $_getSZ(4);
  @$pb.TagNumber(5)
  set target($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTarget() => $_has(4);
  @$pb.TagNumber(5)
  void clearTarget() => clearField(5);
}

class GalleryModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GalleryModel', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'visible')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileSize', protoName: 'fileSize')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'favorited', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxPageIndex', $pb.PbFieldType.O3, protoName: 'maxPageIndex')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageCount', $pb.PbFieldType.O3, protoName: 'imageCount')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'language')
    ..aOM<GalleryBase>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parent', subBuilder: GalleryBase.create)
    ..pc<TagModels>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tags', $pb.PbFieldType.PM, subBuilder: TagModels.create)
    ..pc<CommentModel>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comments', $pb.PbFieldType.PM, subBuilder: CommentModel.create)
    ..pc<PreviewImage>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewImages', $pb.PbFieldType.PM, protoName: 'previewImages', subBuilder: PreviewImage.create)
    ..hasRequiredFields = false
  ;

  GalleryModel._() : super();
  factory GalleryModel({
    $core.String? gid,
    $core.String? token,
    $core.String? title,
    $core.bool? visible,
    $core.String? fileSize,
    $core.int? favorited,
    $core.int? maxPageIndex,
    $core.int? imageCount,
    $core.String? language,
    GalleryBase? parent,
    $core.Iterable<TagModels>? tags,
    $core.Iterable<CommentModel>? comments,
    $core.Iterable<PreviewImage>? previewImages,
  }) {
    final _result = create();
    if (gid != null) {
      _result.gid = gid;
    }
    if (token != null) {
      _result.token = token;
    }
    if (title != null) {
      _result.title = title;
    }
    if (visible != null) {
      _result.visible = visible;
    }
    if (fileSize != null) {
      _result.fileSize = fileSize;
    }
    if (favorited != null) {
      _result.favorited = favorited;
    }
    if (maxPageIndex != null) {
      _result.maxPageIndex = maxPageIndex;
    }
    if (imageCount != null) {
      _result.imageCount = imageCount;
    }
    if (language != null) {
      _result.language = language;
    }
    if (parent != null) {
      _result.parent = parent;
    }
    if (tags != null) {
      _result.tags.addAll(tags);
    }
    if (comments != null) {
      _result.comments.addAll(comments);
    }
    if (previewImages != null) {
      _result.previewImages.addAll(previewImages);
    }
    return _result;
  }
  factory GalleryModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GalleryModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GalleryModel clone() => GalleryModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GalleryModel copyWith(void Function(GalleryModel) updates) => super.copyWith((message) => updates(message as GalleryModel)) as GalleryModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryModel create() => GalleryModel._();
  GalleryModel createEmptyInstance() => create();
  static $pb.PbList<GalleryModel> createRepeated() => $pb.PbList<GalleryModel>();
  @$core.pragma('dart2js:noInline')
  static GalleryModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GalleryModel>(create);
  static GalleryModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get visible => $_getBF(3);
  @$pb.TagNumber(4)
  set visible($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVisible() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisible() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fileSize => $_getSZ(4);
  @$pb.TagNumber(5)
  set fileSize($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFileSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileSize() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get favorited => $_getIZ(5);
  @$pb.TagNumber(6)
  set favorited($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFavorited() => $_has(5);
  @$pb.TagNumber(6)
  void clearFavorited() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxPageIndex => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxPageIndex($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxPageIndex() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxPageIndex() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get imageCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set imageCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasImageCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearImageCount() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get language => $_getSZ(8);
  @$pb.TagNumber(9)
  set language($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLanguage() => $_has(8);
  @$pb.TagNumber(9)
  void clearLanguage() => clearField(9);

  @$pb.TagNumber(10)
  GalleryBase get parent => $_getN(9);
  @$pb.TagNumber(10)
  set parent(GalleryBase v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParent() => $_has(9);
  @$pb.TagNumber(10)
  void clearParent() => clearField(10);
  @$pb.TagNumber(10)
  GalleryBase ensureParent() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.List<TagModels> get tags => $_getList(10);

  @$pb.TagNumber(12)
  $core.List<CommentModel> get comments => $_getList(11);

  @$pb.TagNumber(13)
  $core.List<PreviewImage> get previewImages => $_getList(12);
}

