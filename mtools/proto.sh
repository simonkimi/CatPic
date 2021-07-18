cd ../lib/data/models/proto
protoc --dart_out=../gen eh_gallery.proto
protoc --dart_out=../gen eh_storage.proto
protoc --dart_out=../gen eh_preview.proto
protoc --dart_out=../gen eh_download.proto
protoc --dart_out=../gen eh_gallery_img.proto
cd ../gen
rm -rf *.pbenum.dart
rm -rf *.pbjson.dart
rm -rf *.pbserver.dart