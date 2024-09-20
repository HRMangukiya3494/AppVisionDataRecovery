import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_recovery/model/FileModel.dart';

class FileServiceTest {
  static const List<String> imageExtensions = [
    'jpg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'svg',
    'webp',
    'jpeg',
    'heic',
    'ico',
  ];

  static const List<String> videoExtensions = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
    'mkv',
    'webm',
    'm4v',
    '3gp',
    '3g2',
  ];

  static const List<String> audioExtensions = [
    'mp3',
    'mpeg',
    'wav',
    'aac',
    'ogg',
    'flac',
    'alac',
    'wma',
    'm4a',
    'opus',
    'amr'
  ];

  static const List<String> documentExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'odt',
    'ods',
    'odp',
    'rtf',
    'csv',
    'xml',
    'json',
  ];

  static final Set<String> processedFileNames = {};

  static Future<List<String>> getDirectoriesToScan() async {
    return ['/storage/emulated/0/'];
  }

  static Future<List<FileModel>> scanDeletedFiles() async {
    processedFileNames.clear();
    List<String> directoriesToScan = await getDirectoriesToScan();

    List<FileModel> deletedFiles =
        await compute(_performScan, directoriesToScan);

    log('Recovered files: ${deletedFiles.length}');
    return deletedFiles;
  }

  static Future<List<FileModel>> _performScan(
      List<String> directoriesToScan) async {
    List<FileModel> deletedFiles = [];

    for (var directoryPath in directoriesToScan) {
      try {
        Directory dir = Directory(directoryPath);
        if (await dir.exists()) {
          await _scanDirectory(dir, deletedFiles);
        }
      } catch (e) {
        log('Error scanning directory $directoryPath: $e');
      }
    }

    return deletedFiles;
  }

  static Future<void> _scanDirectory(
      Directory directory, List<FileModel> deletedFiles) async {
    try {
      List<FileSystemEntity> entries =
          directory.listSync(recursive: false, followLinks: false).toList();
      int fileCount = 0;

      for (FileSystemEntity entity in entries) {
        if (entity is Directory) {
          if (_shouldSkipDirectory(entity.path)) {
            continue;
          }
          await _scanDirectory(entity, deletedFiles);
        } else if (entity is File) {
          String fileName = entity.path.split('/').last;

          if (fileName.startsWith('.')) {
            continue;
          }

          String fileExtension = fileName.split('.').last.toLowerCase();
          FileType? fileType = _getFileType(fileExtension);

          if (fileType != null && !processedFileNames.contains(fileName)) {
            processedFileNames.add(fileName);
            deletedFiles.add(FileModel(
              id: 0,
              name: fileName,
              path: entity.path,
              type: fileType,
            ));
            fileCount++;
          }
        }
      }

      log('Files found in ${directory.path}: $fileCount');
    } catch (e) {
      log('Error accessing directory ${directory.path}: $e');
    }
  }

  static bool _shouldSkipDirectory(String path) {
    return path.split('/').last.startsWith('Sent') ||
        path.contains('/storage/emulated/0/Android/data/') ||
        path.contains('/storage/emulated/0/Android/obb/') ||
        path.split('/').last.startsWith('Private') ||
        path.split('/').last.startsWith('avatar') ||
        path.split('/').last.startsWith('.');
  }

  static FileType? _getFileType(String fileExtension) {
    if (imageExtensions.contains(fileExtension)) {
      return FileType.image;
    } else if (videoExtensions.contains(fileExtension)) {
      return FileType.video;
    } else if (audioExtensions.contains(fileExtension)) {
      return FileType.audio;
    } else if (documentExtensions.contains(fileExtension)) {
      return FileType.document;
    }
    return null;
  }
}
