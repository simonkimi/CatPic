///
//  Generated code. Do not modify.
//  source: eh_storage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EhFavourite extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EhFavourite', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'favcat', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  EhFavourite._() : super();
  factory EhFavourite({
    $core.int? favcat,
    $core.String? tag,
    $core.int? count,
  }) {
    final _result = create();
    if (favcat != null) {
      _result.favcat = favcat;
    }
    if (tag != null) {
      _result.tag = tag;
    }
    if (count != null) {
      _result.count = count;
    }
    return _result;
  }
  factory EhFavourite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EhFavourite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EhFavourite clone() => EhFavourite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EhFavourite copyWith(void Function(EhFavourite) updates) => super.copyWith((message) => updates(message as EhFavourite)) as EhFavourite; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EhFavourite create() => EhFavourite._();
  EhFavourite createEmptyInstance() => create();
  static $pb.PbList<EhFavourite> createRepeated() => $pb.PbList<EhFavourite>();
  @$core.pragma('dart2js:noInline')
  static EhFavourite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EhFavourite>(create);
  static EhFavourite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get favcat => $_getIZ(0);
  @$pb.TagNumber(1)
  set favcat($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFavcat() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavcat() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get tag => $_getSZ(1);
  @$pb.TagNumber(2)
  set tag($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearTag() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);
}

class EHStorage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EHStorage', createEmptyInstance: create)
    ..pc<EhFavourite>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'favourite', $pb.PbFieldType.PM, subBuilder: EhFavourite.create)
    ..hasRequiredFields = false
  ;

  EHStorage._() : super();
  factory EHStorage({
    $core.Iterable<EhFavourite>? favourite,
  }) {
    final _result = create();
    if (favourite != null) {
      _result.favourite.addAll(favourite);
    }
    return _result;
  }
  factory EHStorage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EHStorage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EHStorage clone() => EHStorage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EHStorage copyWith(void Function(EHStorage) updates) => super.copyWith((message) => updates(message as EHStorage)) as EHStorage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EHStorage create() => EHStorage._();
  EHStorage createEmptyInstance() => create();
  static $pb.PbList<EHStorage> createRepeated() => $pb.PbList<EHStorage>();
  @$core.pragma('dart2js:noInline')
  static EHStorage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EHStorage>(create);
  static EHStorage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<EhFavourite> get favourite => $_getList(0);
}

