//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class FileData {
  /// Returns a new [FileData] instance.
  FileData({
    required this.fid,
    required this.url,
    required this.name,
    required this.plugin,
    required this.size,
    required this.formatSize,
    required this.status,
    required this.statusmsg,
    required this.packageId,
    required this.error,
    required this.order,
  });

  int fid;

  String url;

  String name;

  String plugin;

  int size;

  String formatSize;

  DownloadStatus status;

  String statusmsg;

  int packageId;

  String error;

  int order;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FileData &&
    other.fid == fid &&
    other.url == url &&
    other.name == name &&
    other.plugin == plugin &&
    other.size == size &&
    other.formatSize == formatSize &&
    other.status == status &&
    other.statusmsg == statusmsg &&
    other.packageId == packageId &&
    other.error == error &&
    other.order == order;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fid.hashCode) +
    (url.hashCode) +
    (name.hashCode) +
    (plugin.hashCode) +
    (size.hashCode) +
    (formatSize.hashCode) +
    (status.hashCode) +
    (statusmsg.hashCode) +
    (packageId.hashCode) +
    (error.hashCode) +
    (order.hashCode);

  @override
  String toString() => 'FileData[fid=$fid, url=$url, name=$name, plugin=$plugin, size=$size, formatSize=$formatSize, status=$status, statusmsg=$statusmsg, packageId=$packageId, error=$error, order=$order]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fid'] = this.fid;
      json[r'url'] = this.url;
      json[r'name'] = this.name;
      json[r'plugin'] = this.plugin;
      json[r'size'] = this.size;
      json[r'format_size'] = this.formatSize;
      json[r'status'] = this.status;
      json[r'statusmsg'] = this.statusmsg;
      json[r'package_id'] = this.packageId;
      json[r'error'] = this.error;
      json[r'order'] = this.order;
    return json;
  }

  /// Returns a new [FileData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FileData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "FileData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FileData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FileData(
        fid: mapValueOfType<int>(json, r'fid')!,
        url: mapValueOfType<String>(json, r'url')!,
        name: mapValueOfType<String>(json, r'name')!,
        plugin: mapValueOfType<String>(json, r'plugin')!,
        size: mapValueOfType<int>(json, r'size')!,
        formatSize: mapValueOfType<String>(json, r'format_size')!,
        status: DownloadStatus.fromJson(json[r'status'])!,
        statusmsg: mapValueOfType<String>(json, r'statusmsg')!,
        packageId: mapValueOfType<int>(json, r'package_id')!,
        error: mapValueOfType<String>(json, r'error')!,
        order: mapValueOfType<int>(json, r'order')!,
      );
    }
    return null;
  }

  static List<FileData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FileData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FileData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FileData> mapFromJson(dynamic json) {
    final map = <String, FileData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FileData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FileData-objects as value to a dart map
  static Map<String, List<FileData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FileData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FileData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fid',
    'url',
    'name',
    'plugin',
    'size',
    'format_size',
    'status',
    'statusmsg',
    'package_id',
    'error',
    'order',
  };
}

