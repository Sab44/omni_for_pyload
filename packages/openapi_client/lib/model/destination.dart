//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;


class Destination {
  /// Instantiate a new enum with the provided [value].
  const Destination._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  String toString() => value.toString();

  int toJson() => value;

  static const COLLECTOR = Destination._(0);
  static const QUEUE = Destination._(1);

  /// List of all possible values in this [enum][Destination].
  static const values = <Destination>[
    COLLECTOR,
    QUEUE,
  ];

  static Destination? fromJson(dynamic value) => DestinationTypeTransformer().decode(value);

  static List<Destination> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Destination>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Destination.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Destination] to int,
/// and [decode] dynamic data back to [Destination].
class DestinationTypeTransformer {
  factory DestinationTypeTransformer() => _instance ??= const DestinationTypeTransformer._();

  const DestinationTypeTransformer._();

  int encode(Destination data) => data.value;

  /// Decodes a [dynamic value][data] to a Destination.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Destination? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case 0: return Destination.COLLECTOR;
        case 1: return Destination.QUEUE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DestinationTypeTransformer] instance.
  static DestinationTypeTransformer? _instance;
}

