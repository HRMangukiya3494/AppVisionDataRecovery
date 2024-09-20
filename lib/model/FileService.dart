import 'dart:developer';
import 'dart:io';
import 'package:photo_recovery/model/FileModel.dart';

class FileService {
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

  // Track processed file names
  static final Set<String> processedFileNames = {};

  // Get the common directories to scan
  static Future<List<String>> getDirectoriesToScan() async {
    final List<String> directoriesToScan = [
      '/storage/emulated/0/', // Root directory
      // Add more directories if needed
    ];
    return directoriesToScan;
  }

  // Scan deleted files
  static Future<List<FileModel>> scanDeletedFiles() async {
    // Clear the processed file names before starting a new scan
    processedFileNames.clear();

    List<FileModel> deletedFiles = [];
    List<String> directoriesToScan = await getDirectoriesToScan();

    for (var directoryPath in directoriesToScan) {
      try {
        Directory dir = Directory(directoryPath);
        if (await dir.exists()) {
          log('Scanning directory: $directoryPath');

          await _scanDirectory(dir, deletedFiles);
        } else {
          log('Directory does not exist: $directoryPath');
        }
      } catch (e) {
        log('Error scanning directory $directoryPath: $e');
      }
    }

    log('Recovered files: ${deletedFiles.length}');
    return deletedFiles;
  }

  // Recursively scan directory and its subdirectories
  static Future<void> _scanDirectory(
      Directory directory, List<FileModel> deletedFiles) async {
    try {
      List<FileSystemEntity> entries =
          directory.listSync(recursive: false, followLinks: false).toList();
      int fileCount = 0;

      for (FileSystemEntity entity in entries) {
        if (entity is Directory) {
          if (_shouldSkipDirectory(entity.path)) {
            log('Skipping directory: ${entity.path}');
            continue;
          }

          // Recursively scan subdirectories
          await _scanDirectory(entity, deletedFiles);
        } else if (entity is File) {
          String fileName = entity.path.split('/').last;

          // Skip files starting with a dot
          if (fileName.startsWith('.')) {
            log('Skipping file: ${entity.path}');
            continue;
          }

          String fileExtension = fileName.split('.').last.toLowerCase();
          FileType? fileType = _getFileType(fileExtension);

          // Check if file type is supported and file has not been processed
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

  // Determines if a directory should be skipped
  static bool _shouldSkipDirectory(String path) {
    return path.split('/').last.startsWith('Sent') ||
        path.contains('/storage/emulated/0/Android/data/') ||
        path.contains('/storage/emulated/0/Android/obb/') ||
        path.split('/').last.startsWith('Private') ||
        path.split('/').last.startsWith('avatar') ||
        path.split('/').last.startsWith('.');
  }

  // Get file type based on extension
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
