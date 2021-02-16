import 'dart:convert' show json;

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    print('$e');
    print('$stack');
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return bool.fromEnvironment(value.toString()) as T;
    }
  }
  return null;
}

class Root {
  Root({
    int id,
    String tags,
    int createdAt,
    int updatedAt,
    int creatorId,
    Object approverId,
    String author,
    int change,
    String source,
    int score,
    String md5,
    int fileSize,
    String fileExt,
    String fileUrl,
    bool isShownInIndex,
    String previewUrl,
    int previewWidth,
    int previewHeight,
    int actualPreviewWidth,
    int actualPreviewHeight,
    String sampleUrl,
    int sampleWidth,
    int sampleHeight,
    int sampleFileSize,
    String jpegUrl,
    int jpegWidth,
    int jpegHeight,
    int jpegFileSize,
    String rating,
    bool isRatingLocked,
    bool hasChildren,
    Object parentId,
    String status,
    bool isPending,
    int width,
    int height,
    bool isHeld,
    String framesPendingString,
    List<Object> framesPending,
    String framesString,
    List<Object> frames,
    bool isNoteLocked,
    int lastNotedAt,
    int lastCommentedAt,
  })  : _id = id,
        _tags = tags,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _creatorId = creatorId,
        _approverId = approverId,
        _author = author,
        _change = change,
        _source = source,
        _score = score,
        _md5 = md5,
        _fileSize = fileSize,
        _fileExt = fileExt,
        _fileUrl = fileUrl,
        _isShownInIndex = isShownInIndex,
        _previewUrl = previewUrl,
        _previewWidth = previewWidth,
        _previewHeight = previewHeight,
        _actualPreviewWidth = actualPreviewWidth,
        _actualPreviewHeight = actualPreviewHeight,
        _sampleUrl = sampleUrl,
        _sampleWidth = sampleWidth,
        _sampleHeight = sampleHeight,
        _sampleFileSize = sampleFileSize,
        _jpegUrl = jpegUrl,
        _jpegWidth = jpegWidth,
        _jpegHeight = jpegHeight,
        _jpegFileSize = jpegFileSize,
        _rating = rating,
        _isRatingLocked = isRatingLocked,
        _hasChildren = hasChildren,
        _parentId = parentId,
        _status = status,
        _isPending = isPending,
        _width = width,
        _height = height,
        _isHeld = isHeld,
        _framesPendingString = framesPendingString,
        _framesPending = framesPending,
        _framesString = framesString,
        _frames = frames,
        _isNoteLocked = isNoteLocked,
        _lastNotedAt = lastNotedAt,
        _lastCommentedAt = lastCommentedAt;
  factory Root.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<Object> framesPending =
        jsonRes['frames_pending'] is List ? <Object>[] : null;
    if (framesPending != null) {
      for (final dynamic item in jsonRes['frames_pending']) {
        if (item != null) {
          tryCatch(() {
            framesPending.add(asT<Object>(item));
          });
        }
      }
    }

    final List<Object> frames = jsonRes['frames'] is List ? <Object>[] : null;
    if (frames != null) {
      for (final dynamic item in jsonRes['frames']) {
        if (item != null) {
          tryCatch(() {
            frames.add(asT<Object>(item));
          });
        }
      }
    }

    return Root(
      id: asT<int>(jsonRes['id']),
      tags: asT<String>(jsonRes['tags']),
      createdAt: asT<int>(jsonRes['created_at']),
      updatedAt: asT<int>(jsonRes['updated_at']),
      creatorId: asT<int>(jsonRes['creator_id']),
      approverId: asT<Object>(jsonRes['approver_id']),
      author: asT<String>(jsonRes['author']),
      change: asT<int>(jsonRes['change']),
      source: asT<String>(jsonRes['source']),
      score: asT<int>(jsonRes['score']),
      md5: asT<String>(jsonRes['md5']),
      fileSize: asT<int>(jsonRes['file_size']),
      fileExt: asT<String>(jsonRes['file_ext']),
      fileUrl: asT<String>(jsonRes['file_url']),
      isShownInIndex: asT<bool>(jsonRes['is_shown_in_index']),
      previewUrl: asT<String>(jsonRes['preview_url']),
      previewWidth: asT<int>(jsonRes['preview_width']),
      previewHeight: asT<int>(jsonRes['preview_height']),
      actualPreviewWidth: asT<int>(jsonRes['actual_preview_width']),
      actualPreviewHeight: asT<int>(jsonRes['actual_preview_height']),
      sampleUrl: asT<String>(jsonRes['sample_url']),
      sampleWidth: asT<int>(jsonRes['sample_width']),
      sampleHeight: asT<int>(jsonRes['sample_height']),
      sampleFileSize: asT<int>(jsonRes['sample_file_size']),
      jpegUrl: asT<String>(jsonRes['jpeg_url']),
      jpegWidth: asT<int>(jsonRes['jpeg_width']),
      jpegHeight: asT<int>(jsonRes['jpeg_height']),
      jpegFileSize: asT<int>(jsonRes['jpeg_file_size']),
      rating: asT<String>(jsonRes['rating']),
      isRatingLocked: asT<bool>(jsonRes['is_rating_locked']),
      hasChildren: asT<bool>(jsonRes['has_children']),
      parentId: asT<Object>(jsonRes['parent_id']),
      status: asT<String>(jsonRes['status']),
      isPending: asT<bool>(jsonRes['is_pending']),
      width: asT<int>(jsonRes['width']),
      height: asT<int>(jsonRes['height']),
      isHeld: asT<bool>(jsonRes['is_held']),
      framesPendingString: asT<String>(jsonRes['frames_pending_string']),
      framesPending: framesPending,
      framesString: asT<String>(jsonRes['frames_string']),
      frames: frames,
      isNoteLocked: asT<bool>(jsonRes['is_note_locked']),
      lastNotedAt: asT<int>(jsonRes['last_noted_at']),
      lastCommentedAt: asT<int>(jsonRes['last_commented_at']),
    );
  }

  int _id;
  int get id => _id;
  String _tags;
  String get tags => _tags;
  int _createdAt;
  int get createdAt => _createdAt;
  int _updatedAt;
  int get updatedAt => _updatedAt;
  int _creatorId;
  int get creatorId => _creatorId;
  Object _approverId;
  Object get approverId => _approverId;
  String _author;
  String get author => _author;
  int _change;
  int get change => _change;
  String _source;
  String get source => _source;
  int _score;
  int get score => _score;
  String _md5;
  String get md5 => _md5;
  int _fileSize;
  int get fileSize => _fileSize;
  String _fileExt;
  String get fileExt => _fileExt;
  String _fileUrl;
  String get fileUrl => _fileUrl;
  bool _isShownInIndex;
  bool get isShownInIndex => _isShownInIndex;
  String _previewUrl;
  String get previewUrl => _previewUrl;
  int _previewWidth;
  int get previewWidth => _previewWidth;
  int _previewHeight;
  int get previewHeight => _previewHeight;
  int _actualPreviewWidth;
  int get actualPreviewWidth => _actualPreviewWidth;
  int _actualPreviewHeight;
  int get actualPreviewHeight => _actualPreviewHeight;
  String _sampleUrl;
  String get sampleUrl => _sampleUrl;
  int _sampleWidth;
  int get sampleWidth => _sampleWidth;
  int _sampleHeight;
  int get sampleHeight => _sampleHeight;
  int _sampleFileSize;
  int get sampleFileSize => _sampleFileSize;
  String _jpegUrl;
  String get jpegUrl => _jpegUrl;
  int _jpegWidth;
  int get jpegWidth => _jpegWidth;
  int _jpegHeight;
  int get jpegHeight => _jpegHeight;
  int _jpegFileSize;
  int get jpegFileSize => _jpegFileSize;
  String _rating;
  String get rating => _rating;
  bool _isRatingLocked;
  bool get isRatingLocked => _isRatingLocked;
  bool _hasChildren;
  bool get hasChildren => _hasChildren;
  Object _parentId;
  Object get parentId => _parentId;
  String _status;
  String get status => _status;
  bool _isPending;
  bool get isPending => _isPending;
  int _width;
  int get width => _width;
  int _height;
  int get height => _height;
  bool _isHeld;
  bool get isHeld => _isHeld;
  String _framesPendingString;
  String get framesPendingString => _framesPendingString;
  List<Object> _framesPending;
  List<Object> get framesPending => _framesPending;
  String _framesString;
  String get framesString => _framesString;
  List<Object> _frames;
  List<Object> get frames => _frames;
  bool _isNoteLocked;
  bool get isNoteLocked => _isNoteLocked;
  int _lastNotedAt;
  int get lastNotedAt => _lastNotedAt;
  int _lastCommentedAt;
  int get lastCommentedAt => _lastCommentedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': _id,
        'tags': _tags,
        'created_at': _createdAt,
        'updated_at': _updatedAt,
        'creator_id': _creatorId,
        'approver_id': _approverId,
        'author': _author,
        'change': _change,
        'source': _source,
        'score': _score,
        'md5': _md5,
        'file_size': _fileSize,
        'file_ext': _fileExt,
        'file_url': _fileUrl,
        'is_shown_in_index': _isShownInIndex,
        'preview_url': _previewUrl,
        'preview_width': _previewWidth,
        'preview_height': _previewHeight,
        'actual_preview_width': _actualPreviewWidth,
        'actual_preview_height': _actualPreviewHeight,
        'sample_url': _sampleUrl,
        'sample_width': _sampleWidth,
        'sample_height': _sampleHeight,
        'sample_file_size': _sampleFileSize,
        'jpeg_url': _jpegUrl,
        'jpeg_width': _jpegWidth,
        'jpeg_height': _jpegHeight,
        'jpeg_file_size': _jpegFileSize,
        'rating': _rating,
        'is_rating_locked': _isRatingLocked,
        'has_children': _hasChildren,
        'parent_id': _parentId,
        'status': _status,
        'is_pending': _isPending,
        'width': _width,
        'height': _height,
        'is_held': _isHeld,
        'frames_pending_string': _framesPendingString,
        'frames_pending': _framesPending,
        'frames_string': _framesString,
        'frames': _frames,
        'is_note_locked': _isNoteLocked,
        'last_noted_at': _lastNotedAt,
        'last_commented_at': _lastCommentedAt,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
