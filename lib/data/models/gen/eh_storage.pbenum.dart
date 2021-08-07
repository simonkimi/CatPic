///
//  Generated code. Do not modify.
//  source: eh_storage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ReadAxis extends $pb.ProtobufEnum {
  static const ReadAxis leftToRight = ReadAxis._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'leftToRight');
  static const ReadAxis rightToLeft = ReadAxis._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'rightToLeft');
  static const ReadAxis topToButton = ReadAxis._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'topToButton');

  static const $core.List<ReadAxis> values = <ReadAxis>[
    leftToRight,
    rightToLeft,
    topToButton,
  ];

  static final $core.Map<$core.int, ReadAxis> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ReadAxis? valueOf($core.int value) => _byValue[value];

  const ReadAxis._($core.int v, $core.String n) : super(v, n);
}

class ScreenAxis extends $pb.ProtobufEnum {
  static const ScreenAxis horizontalLeft = ScreenAxis._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'horizontalLeft');
  static const ScreenAxis horizontalRight = ScreenAxis._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'horizontalRight');
  static const ScreenAxis vertical = ScreenAxis._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'vertical');
  static const ScreenAxis system = ScreenAxis._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'system');

  static const $core.List<ScreenAxis> values = <ScreenAxis>[
    horizontalLeft,
    horizontalRight,
    vertical,
    system,
  ];

  static final $core.Map<$core.int, ScreenAxis> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ScreenAxis? valueOf($core.int value) => _byValue[value];

  const ScreenAxis._($core.int v, $core.String n) : super(v, n);
}

class DisplayType extends $pb.ProtobufEnum {
  static const DisplayType Single = DisplayType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'Single');
  static const DisplayType DoubleNormal = DisplayType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'DoubleNormal');
  static const DisplayType DoubleCover = DisplayType._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'DoubleCover');

  static const $core.List<DisplayType> values = <DisplayType>[
    Single,
    DoubleNormal,
    DoubleCover,
  ];

  static final $core.Map<$core.int, DisplayType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static DisplayType? valueOf($core.int value) => _byValue[value];

  const DisplayType._($core.int v, $core.String n) : super(v, n);
}
