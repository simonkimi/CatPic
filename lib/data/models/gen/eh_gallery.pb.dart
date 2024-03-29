///
//  Generated code. Do not modify.
//  source: eh_gallery.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class GalleryBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GalleryBase',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gid')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'token')
    ..hasRequiredFields = false;

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
  factory GalleryBase.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GalleryBase.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GalleryBase clone() => GalleryBase()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GalleryBase copyWith(void Function(GalleryBase) updates) =>
      super.copyWith((message) => updates(message as GalleryBase))
          as GalleryBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryBase create() => GalleryBase._();
  GalleryBase createEmptyInstance() => create();
  static $pb.PbList<GalleryBase> createRepeated() => $pb.PbList<GalleryBase>();
  @$core.pragma('dart2js:noInline')
  static GalleryBase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GalleryBase>(create);
  static GalleryBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class GalleryUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GalleryUpdate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gid')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'token')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updateTime',
        protoName: 'updateTime')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..hasRequiredFields = false;

  GalleryUpdate._() : super();
  factory GalleryUpdate({
    $core.String? gid,
    $core.String? token,
    $core.String? updateTime,
    $core.String? title,
  }) {
    final _result = create();
    if (gid != null) {
      _result.gid = gid;
    }
    if (token != null) {
      _result.token = token;
    }
    if (updateTime != null) {
      _result.updateTime = updateTime;
    }
    if (title != null) {
      _result.title = title;
    }
    return _result;
  }
  factory GalleryUpdate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GalleryUpdate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GalleryUpdate clone() => GalleryUpdate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GalleryUpdate copyWith(void Function(GalleryUpdate) updates) =>
      super.copyWith((message) => updates(message as GalleryUpdate))
          as GalleryUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryUpdate create() => GalleryUpdate._();
  GalleryUpdate createEmptyInstance() => create();
  static $pb.PbList<GalleryUpdate> createRepeated() =>
      $pb.PbList<GalleryUpdate>();
  @$core.pragma('dart2js:noInline')
  static GalleryUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GalleryUpdate>(create);
  static GalleryUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get updateTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set updateTime($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUpdateTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => clearField(4);
}

class TagItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TagItem',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'parent')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'translate')
    ..hasRequiredFields = false;

  TagItem._() : super();
  factory TagItem({
    $core.String? parent,
    $core.String? value,
    $core.String? translate,
  }) {
    final _result = create();
    if (parent != null) {
      _result.parent = parent;
    }
    if (value != null) {
      _result.value = value;
    }
    if (translate != null) {
      _result.translate = translate;
    }
    return _result;
  }
  factory TagItem.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TagItem.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TagItem clone() => TagItem()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TagItem copyWith(void Function(TagItem) updates) =>
      super.copyWith((message) => updates(message as TagItem))
          as TagItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TagItem create() => TagItem._();
  TagItem createEmptyInstance() => create();
  static $pb.PbList<TagItem> createRepeated() => $pb.PbList<TagItem>();
  @$core.pragma('dart2js:noInline')
  static TagItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TagItem>(create);
  static TagItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parent => $_getSZ(0);
  @$pb.TagNumber(1)
  set parent($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get translate => $_getSZ(2);
  @$pb.TagNumber(3)
  set translate($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTranslate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTranslate() => clearField(3);
}

class TagModels extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TagModels',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key')
    ..pc<TagItem>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value',
        $pb.PbFieldType.PM,
        subBuilder: TagItem.create)
    ..aOS(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyTranslate',
        protoName: 'keyTranslate')
    ..hasRequiredFields = false;

  TagModels._() : super();
  factory TagModels({
    $core.String? key,
    $core.Iterable<TagItem>? value,
    $core.String? keyTranslate,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value.addAll(value);
    }
    if (keyTranslate != null) {
      _result.keyTranslate = keyTranslate;
    }
    return _result;
  }
  factory TagModels.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TagModels.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TagModels clone() => TagModels()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TagModels copyWith(void Function(TagModels) updates) =>
      super.copyWith((message) => updates(message as TagModels))
          as TagModels; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TagModels create() => TagModels._();
  TagModels createEmptyInstance() => create();
  static $pb.PbList<TagModels> createRepeated() => $pb.PbList<TagModels>();
  @$core.pragma('dart2js:noInline')
  static TagModels getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TagModels>(create);
  static TagModels? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<TagItem> get value => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get keyTranslate => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyTranslate($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasKeyTranslate() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyTranslate() => clearField(3);
}

class CommentModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CommentModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'username')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'comment')
    ..aOS(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commentTime',
        protoName: 'commentTime')
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'score',
        $pb.PbFieldType.O3)
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voteUser', protoName: 'voteUser')
    ..hasRequiredFields = false;

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
  factory CommentModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CommentModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CommentModel clone() => CommentModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CommentModel copyWith(void Function(CommentModel) updates) =>
      super.copyWith((message) => updates(message as CommentModel))
          as CommentModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CommentModel create() => CommentModel._();
  CommentModel createEmptyInstance() => create();
  static $pb.PbList<CommentModel> createRepeated() =>
      $pb.PbList<CommentModel>();
  @$core.pragma('dart2js:noInline')
  static CommentModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentModel>(create);
  static CommentModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(2)
  set comment($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentTime($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCommentTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get score => $_getIZ(3);
  @$pb.TagNumber(4)
  set score($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get voteUser => $_getList(4);
}

class GalleryPreviewImageModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GalleryPreviewImageModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shaToken',
        protoName: 'shaToken')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isLarge',
        protoName: 'isLarge')
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height',
        $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.O3)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageUrl', protoName: 'imageUrl')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'positioning', $pb.PbFieldType.O3)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'page', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  GalleryPreviewImageModel._() : super();
  factory GalleryPreviewImageModel({
    $core.String? gid,
    $core.String? shaToken,
    $core.bool? isLarge,
    $core.int? height,
    $core.int? width,
    $core.String? imageUrl,
    $core.int? positioning,
    $core.int? page,
  }) {
    final _result = create();
    if (gid != null) {
      _result.gid = gid;
    }
    if (shaToken != null) {
      _result.shaToken = shaToken;
    }
    if (isLarge != null) {
      _result.isLarge = isLarge;
    }
    if (height != null) {
      _result.height = height;
    }
    if (width != null) {
      _result.width = width;
    }
    if (imageUrl != null) {
      _result.imageUrl = imageUrl;
    }
    if (positioning != null) {
      _result.positioning = positioning;
    }
    if (page != null) {
      _result.page = page;
    }
    return _result;
  }
  factory GalleryPreviewImageModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GalleryPreviewImageModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GalleryPreviewImageModel clone() =>
      GalleryPreviewImageModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GalleryPreviewImageModel copyWith(
          void Function(GalleryPreviewImageModel) updates) =>
      super.copyWith((message) => updates(message as GalleryPreviewImageModel))
          as GalleryPreviewImageModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryPreviewImageModel create() => GalleryPreviewImageModel._();
  GalleryPreviewImageModel createEmptyInstance() => create();
  static $pb.PbList<GalleryPreviewImageModel> createRepeated() =>
      $pb.PbList<GalleryPreviewImageModel>();
  @$core.pragma('dart2js:noInline')
  static GalleryPreviewImageModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GalleryPreviewImageModel>(create);
  static GalleryPreviewImageModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get shaToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set shaToken($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasShaToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearShaToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLarge => $_getBF(2);
  @$pb.TagNumber(3)
  set isLarge($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIsLarge() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLarge() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(6)
  $core.int get width => $_getIZ(4);
  @$pb.TagNumber(6)
  set width($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasWidth() => $_has(4);
  @$pb.TagNumber(6)
  void clearWidth() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get imageUrl => $_getSZ(5);
  @$pb.TagNumber(7)
  set imageUrl($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasImageUrl() => $_has(5);
  @$pb.TagNumber(7)
  void clearImageUrl() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get positioning => $_getIZ(6);
  @$pb.TagNumber(8)
  set positioning($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPositioning() => $_has(6);
  @$pb.TagNumber(8)
  void clearPositioning() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get page => $_getIZ(7);
  @$pb.TagNumber(9)
  set page($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPage() => $_has(7);
  @$pb.TagNumber(9)
  void clearPage() => clearField(9);
}

class GalleryModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GalleryModel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ehentai'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gid')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'token')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'title')
    ..aOS(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'visible')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileSize', protoName: 'fileSize')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'favorited', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxPageIndex', $pb.PbFieldType.O3, protoName: 'maxPageIndex')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageCount', $pb.PbFieldType.O3, protoName: 'imageCount')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'language')
    ..aOM<GalleryBase>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parent', subBuilder: GalleryBase.create)
    ..pc<TagModels>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tags', $pb.PbFieldType.PM, subBuilder: TagModels.create)
    ..pc<CommentModel>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comments', $pb.PbFieldType.PM, subBuilder: CommentModel.create)
    ..pc<GalleryPreviewImageModel>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewImages', $pb.PbFieldType.PM, protoName: 'previewImages', subBuilder: GalleryPreviewImageModel.create)
    ..a<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'favcat', $pb.PbFieldType.O3)
    ..a<$core.int>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'torrentNum', $pb.PbFieldType.O3, protoName: 'torrentNum')
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'japanTitle', protoName: 'japanTitle')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewImage', protoName: 'previewImage')
    ..aOS(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploader')
    ..aOS(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadTime', protoName: 'uploadTime')
    ..a<$core.double>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'star', $pb.PbFieldType.OD)
    ..a<$core.int>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'starMember', $pb.PbFieldType.O3, protoName: 'starMember')
    ..a<$core.int>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag', $pb.PbFieldType.O3)
    ..pc<GalleryUpdate>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updates', $pb.PbFieldType.PM, subBuilder: GalleryUpdate.create)
    ..a<$core.int>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewWidth', $pb.PbFieldType.O3, protoName: 'previewWidth')
    ..a<$core.int>(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previewHeight', $pb.PbFieldType.O3, protoName: 'previewHeight')
    ..a<$core.int>(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageCountInOnePage', $pb.PbFieldType.O3, protoName: 'imageCountInOnePage')
    ..a<$core.int>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentPage', $pb.PbFieldType.O3, protoName: 'currentPage')
    ..a<$core.int>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startImageIndex', $pb.PbFieldType.O3, protoName: 'startImageIndex')
    ..a<$core.int>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endImageIndex', $pb.PbFieldType.O3, protoName: 'endImageIndex')
    ..hasRequiredFields = false;

  GalleryModel._() : super();
  factory GalleryModel({
    $core.String? gid,
    $core.String? token,
    $core.String? title,
    $core.String? visible,
    $core.String? fileSize,
    $core.int? favorited,
    $core.int? maxPageIndex,
    $core.int? imageCount,
    $core.String? language,
    GalleryBase? parent,
    $core.Iterable<TagModels>? tags,
    $core.Iterable<CommentModel>? comments,
    $core.Iterable<GalleryPreviewImageModel>? previewImages,
    $core.int? favcat,
    $core.int? torrentNum,
    $core.String? japanTitle,
    $core.String? previewImage,
    $core.String? uploader,
    $core.String? uploadTime,
    $core.double? star,
    $core.int? starMember,
    $core.int? tag,
    $core.Iterable<GalleryUpdate>? updates,
    $core.int? previewWidth,
    $core.int? previewHeight,
    $core.int? imageCountInOnePage,
    $core.int? currentPage,
    $core.int? startImageIndex,
    $core.int? endImageIndex,
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
    if (favcat != null) {
      _result.favcat = favcat;
    }
    if (torrentNum != null) {
      _result.torrentNum = torrentNum;
    }
    if (japanTitle != null) {
      _result.japanTitle = japanTitle;
    }
    if (previewImage != null) {
      _result.previewImage = previewImage;
    }
    if (uploader != null) {
      _result.uploader = uploader;
    }
    if (uploadTime != null) {
      _result.uploadTime = uploadTime;
    }
    if (star != null) {
      _result.star = star;
    }
    if (starMember != null) {
      _result.starMember = starMember;
    }
    if (tag != null) {
      _result.tag = tag;
    }
    if (updates != null) {
      _result.updates.addAll(updates);
    }
    if (previewWidth != null) {
      _result.previewWidth = previewWidth;
    }
    if (previewHeight != null) {
      _result.previewHeight = previewHeight;
    }
    if (imageCountInOnePage != null) {
      _result.imageCountInOnePage = imageCountInOnePage;
    }
    if (currentPage != null) {
      _result.currentPage = currentPage;
    }
    if (startImageIndex != null) {
      _result.startImageIndex = startImageIndex;
    }
    if (endImageIndex != null) {
      _result.endImageIndex = endImageIndex;
    }
    return _result;
  }
  factory GalleryModel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GalleryModel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GalleryModel clone() => GalleryModel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GalleryModel copyWith(void Function(GalleryModel) updates) =>
      super.copyWith((message) => updates(message as GalleryModel))
          as GalleryModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GalleryModel create() => GalleryModel._();
  GalleryModel createEmptyInstance() => create();
  static $pb.PbList<GalleryModel> createRepeated() =>
      $pb.PbList<GalleryModel>();
  @$core.pragma('dart2js:noInline')
  static GalleryModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GalleryModel>(create);
  static GalleryModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get visible => $_getSZ(3);
  @$pb.TagNumber(4)
  set visible($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasVisible() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisible() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fileSize => $_getSZ(4);
  @$pb.TagNumber(5)
  set fileSize($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasFileSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileSize() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get favorited => $_getIZ(5);
  @$pb.TagNumber(6)
  set favorited($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFavorited() => $_has(5);
  @$pb.TagNumber(6)
  void clearFavorited() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxPageIndex => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxPageIndex($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMaxPageIndex() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxPageIndex() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get imageCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set imageCount($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasImageCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearImageCount() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get language => $_getSZ(8);
  @$pb.TagNumber(9)
  set language($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLanguage() => $_has(8);
  @$pb.TagNumber(9)
  void clearLanguage() => clearField(9);

  @$pb.TagNumber(10)
  GalleryBase get parent => $_getN(9);
  @$pb.TagNumber(10)
  set parent(GalleryBase v) {
    setField(10, v);
  }

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
  $core.List<GalleryPreviewImageModel> get previewImages => $_getList(12);

  @$pb.TagNumber(14)
  $core.int get favcat => $_getIZ(13);
  @$pb.TagNumber(14)
  set favcat($core.int v) {
    $_setSignedInt32(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasFavcat() => $_has(13);
  @$pb.TagNumber(14)
  void clearFavcat() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get torrentNum => $_getIZ(14);
  @$pb.TagNumber(15)
  set torrentNum($core.int v) {
    $_setSignedInt32(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasTorrentNum() => $_has(14);
  @$pb.TagNumber(15)
  void clearTorrentNum() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get japanTitle => $_getSZ(15);
  @$pb.TagNumber(16)
  set japanTitle($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasJapanTitle() => $_has(15);
  @$pb.TagNumber(16)
  void clearJapanTitle() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get previewImage => $_getSZ(16);
  @$pb.TagNumber(17)
  set previewImage($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasPreviewImage() => $_has(16);
  @$pb.TagNumber(17)
  void clearPreviewImage() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get uploader => $_getSZ(17);
  @$pb.TagNumber(18)
  set uploader($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasUploader() => $_has(17);
  @$pb.TagNumber(18)
  void clearUploader() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get uploadTime => $_getSZ(18);
  @$pb.TagNumber(19)
  set uploadTime($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasUploadTime() => $_has(18);
  @$pb.TagNumber(19)
  void clearUploadTime() => clearField(19);

  @$pb.TagNumber(20)
  $core.double get star => $_getN(19);
  @$pb.TagNumber(20)
  set star($core.double v) {
    $_setDouble(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasStar() => $_has(19);
  @$pb.TagNumber(20)
  void clearStar() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get starMember => $_getIZ(20);
  @$pb.TagNumber(21)
  set starMember($core.int v) {
    $_setSignedInt32(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasStarMember() => $_has(20);
  @$pb.TagNumber(21)
  void clearStarMember() => clearField(21);

  @$pb.TagNumber(22)
  $core.int get tag => $_getIZ(21);
  @$pb.TagNumber(22)
  set tag($core.int v) {
    $_setSignedInt32(21, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasTag() => $_has(21);
  @$pb.TagNumber(22)
  void clearTag() => clearField(22);

  @$pb.TagNumber(23)
  $core.List<GalleryUpdate> get updates => $_getList(22);

  @$pb.TagNumber(24)
  $core.int get previewWidth => $_getIZ(23);
  @$pb.TagNumber(24)
  set previewWidth($core.int v) {
    $_setSignedInt32(23, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasPreviewWidth() => $_has(23);
  @$pb.TagNumber(24)
  void clearPreviewWidth() => clearField(24);

  @$pb.TagNumber(25)
  $core.int get previewHeight => $_getIZ(24);
  @$pb.TagNumber(25)
  set previewHeight($core.int v) {
    $_setSignedInt32(24, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasPreviewHeight() => $_has(24);
  @$pb.TagNumber(25)
  void clearPreviewHeight() => clearField(25);

  @$pb.TagNumber(26)
  $core.int get imageCountInOnePage => $_getIZ(25);
  @$pb.TagNumber(26)
  set imageCountInOnePage($core.int v) {
    $_setSignedInt32(25, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasImageCountInOnePage() => $_has(25);
  @$pb.TagNumber(26)
  void clearImageCountInOnePage() => clearField(26);

  @$pb.TagNumber(27)
  $core.int get currentPage => $_getIZ(26);
  @$pb.TagNumber(27)
  set currentPage($core.int v) {
    $_setSignedInt32(26, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasCurrentPage() => $_has(26);
  @$pb.TagNumber(27)
  void clearCurrentPage() => clearField(27);

  @$pb.TagNumber(28)
  $core.int get startImageIndex => $_getIZ(27);
  @$pb.TagNumber(28)
  set startImageIndex($core.int v) {
    $_setSignedInt32(27, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasStartImageIndex() => $_has(27);
  @$pb.TagNumber(28)
  void clearStartImageIndex() => clearField(28);

  @$pb.TagNumber(29)
  $core.int get endImageIndex => $_getIZ(28);
  @$pb.TagNumber(29)
  set endImageIndex($core.int v) {
    $_setSignedInt32(28, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasEndImageIndex() => $_has(28);
  @$pb.TagNumber(29)
  void clearEndImageIndex() => clearField(29);
}
