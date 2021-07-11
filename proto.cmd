cd lib\data\models\proto
protoc --dart_out=..\gen eh_gallery.proto
protoc --dart_out=..\gen eh_storage.proto
protoc --dart_out=..\gen eh_preview.proto
protoc --dart_out=..\gen eh_download.proto
cd ..
cd gen
del /q *.pbenum.dart
del /q *.pbjson.dart
del /q *.pbserver.dart
cd ..\..\..\..