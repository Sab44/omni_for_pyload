//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;


class DownloadStatus {
  /// Instantiate a new enum with the provided [value].
  const DownloadStatus._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  String toString() => value.toString();

  int toJson() => value;

  static const ABORTED = DownloadStatus._(9);
  static const CUSTOM = DownloadStatus._(11);
  static const DECRYPTING = DownloadStatus._(10);
  static const DOWNLOADING = DownloadStatus._(12);
  static const FAILED = DownloadStatus._(8);
  static const FINISHED = DownloadStatus._(0);
  static const OFFLINE = DownloadStatus._(1);
  static const ONLINE = DownloadStatus._(2);
  static const PROCESSING = DownloadStatus._(13);
  static const QUEUED = DownloadStatus._(3);
  static const SKIPPED = DownloadStatus._(4);
  static const STARTING = DownloadStatus._(7);
  static const TEMPOFFLINE = DownloadStatus._(6);
  static const UNKNOWN = DownloadStatus._(14);
  static const WAITING = DownloadStatus._(5);

  /// List of all possible values in this [enum][DownloadStatus].
  static const values = <DownloadStatus>[
    ABORTED,
    CUSTOM,
    DECRYPTING,
    DOWNLOADING,
    FAILED,
    FINISHED,
    OFFLINE,
    ONLINE,
    PROCESSING,
    QUEUED,
    SKIPPED,
    STARTING,
    TEMPOFFLINE,
    UNKNOWN,
    WAITING,
  ];

  static DownloadStatus? fromJson(dynamic value) => DownloadStatusTypeTransformer().decode(value);

  static List<DownloadStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DownloadStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DownloadStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DownloadStatus] to int,
/// and [decode] dynamic data back to [DownloadStatus].
class DownloadStatusTypeTransformer {
  factory DownloadStatusTypeTransformer() => _instance ??= const DownloadStatusTypeTransformer._();

  const DownloadStatusTypeTransformer._();

  int encode(DownloadStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a DownloadStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DownloadStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case 9: return DownloadStatus.ABORTED;
        case 11: return DownloadStatus.CUSTOM;
        case 10: return DownloadStatus.DECRYPTING;
        case 12: return DownloadStatus.DOWNLOADING;
        case 8: return DownloadStatus.FAILED;
        case 0: return DownloadStatus.FINISHED;
        case 1: return DownloadStatus.OFFLINE;
        case 2: return DownloadStatus.ONLINE;
        case 13: return DownloadStatus.PROCESSING;
        case 3: return DownloadStatus.QUEUED;
        case 4: return DownloadStatus.SKIPPED;
        case 7: return DownloadStatus.STARTING;
        case 6: return DownloadStatus.TEMPOFFLINE;
        case 14: return DownloadStatus.UNKNOWN;
        case 5: return DownloadStatus.WAITING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DownloadStatusTypeTransformer] instance.
  static DownloadStatusTypeTransformer? _instance;
}

