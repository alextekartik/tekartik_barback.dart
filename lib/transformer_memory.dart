library transformer_utils;

import 'dart:async';
import 'package:source_span/source_span.dart' as source_span;
import 'dart:convert';
import 'dart:collection';
import 'transformer.dart';
import 'transformer.dart' as common;
export 'transformer.dart';

class MemoryAsset implements common.Asset {
  String content;

  @override
  final AssetId id;

  Future<String> readAsString({Encoding encoding}) async {
    return content;
  }

  MemoryAsset.fromString(this.id, this.content);
}

/// A set of [MemoryAsset]s with distinct IDs.
///
/// This uses the [AssetId] of each asset to determine uniqueness, so no two
/// assets with the same ID can be in the set.
class MemoryAssetSet extends Object
    with IterableMixin<Asset>
    implements common.AssetSet {
  final _assets = new Map<AssetId, MemoryAsset>();

  /// The ids of the assets in the set.
  /// @override
  Iterable<AssetId> get ids => _assets.keys;

  MemoryAssetSet();

  /// Creates a new AssetSet from the contents of [other].
  ///
  /// If multiple assets in [other] have the same id, the last one takes
  /// precedence.
  MemoryAssetSet.from(Iterable<MemoryAsset> other) {
    for (var asset in other) {
      _assets[asset.id] = asset;
    }
  }

  @override
  Iterator<MemoryAsset> get iterator => _assets.values.iterator;

  // int get length => _assets.length;

  /// Gets the [MemoryAsset] in the set with [id], or returns `null` if no asset with
  /// that ID is present.
  @override
  MemoryAsset operator [](AssetId id) => _assets[id];

  /// Adds [asset] to the set.
  ///
  /// If there is already an asset with that ID in the set, it is replaced by
  /// the new one. Returns [asset].
  @override
  MemoryAsset add(MemoryAsset asset) {
    _assets[asset.id] = asset;
    return asset;
  }

  /// Adds [assets] to the set.
  @override
  void addAll(Iterable<MemoryAsset> assets) {
    assets.forEach(add);
  }

  /// Returns `true` if the set contains [asset].
  ///
  /*
  bool contains(MemoryAsset asset) {
    var other = _assets[asset.id];
    return other == asset;
  }
  */

  /// Returns `true` if the set contains an [MemoryAsset] with [id].
  @override
  bool containsId(AssetId id) {
    return _assets.containsKey(id);
  }

  /// If the set contains an [MemoryAsset] with [id], removes and returns it.
  @override
  MemoryAsset removeId(AssetId id) => _assets.remove(id);

  /// Removes all assets from the set.
  @override
  void clear() {
    _assets.clear();
  }

  String toString() => _assets.toString();
}

/// Context create for simulation only with helper
class MemoryTransformerContext {
  MemoryTransformLogger logger;
  MemoryAssetSet assets = new MemoryAssetSet();
  MemoryAssetSet outputs = new MemoryAssetSet();

  clear() {
    assets.clear();
    outputs.clear();
    packageName = null;
  }

  MemoryTransformerContext() {
    // get the package name from t
  }

  String packageName = null;

  // helper
  AssetId addOutput(MemoryAsset asset) {
    outputs.add(asset);
    return addAsset(asset);
  }

  AssetId addAsset(MemoryAsset asset) {
    assets.add(asset);
    return asset.id;
  }

  // to remove
  MemoryAsset newAssetFromString(AssetId id, String content) {
    return new MemoryAsset.fromString(id, content);
  }

  /// add an asset
  /// helper
  AssetId addStringAsset(String path, String content) {
    return addAsset(newAssetFromString(getAssetId(path), content));
  }

  // helper
  AssetId getAssetId(String path) => new AssetId(packageName, path);

  // helper
  String getStringAsset(String path) => getAssetAsString(getAssetId(path));

  Future<String> readAssetAsString(AssetId id, {Encoding encoding}) async {
    return getAssetAsString(id, encoding: encoding);
  }

  AssetId addOutputAssetFromString(AssetId id, String content) {
    MemoryAsset asset = new MemoryAsset.fromString(id, content);
    outputs.add(asset);
    assets.add(asset);
    return id;
  }

  // memory only
  String getAssetAsString(AssetId id, {Encoding encoding}) {
    //outputs.
    MemoryAsset asset = assets[id];
    if (asset == null) {
      return null;
    }
    return asset.content;
  }

  // helper use one that you added already
  MemoryTransform newTransform(AssetId primaryInputId) {
    return new MemoryTransform(this, primaryInputId);
  }
}

/**
 * Used in tests
 */
class MemoryTransform implements Transform {
  MemoryTransformerContext context;
  MemoryTransform(this.context, this.primaryInputId);

  @override
  final AssetId primaryInputId;

  @override
  void consumePrimary() {
    context.assets.removeId(primaryInputId);
  }

  @override
  Future<bool> hasInput(AssetId id) async {
    return context.assets.containsId(id);
  }

  @override
  Future<String> readInputAsString(AssetId id, {Encoding encoding}) =>
      context.readAssetAsString(id, encoding: encoding);

  @override
  AssetId addOutputFromString(AssetId id, String content,
          {Encoding encoding}) =>
      context.addOutputAssetFromString(id, content);

  @override
  Future<String> readPrimaryInputAssetAsString({Encoding encoding}) =>
      readInputAsString(primaryInputId, encoding: encoding);

  MemoryTransformLogger _logger;
  MemoryTransformLogger get logger {
    if (_logger == null) {
      _logger = new MemoryTransformLogger(this);
    }
    return _logger;
  }
}

class BaseTransformLogger implements TransformLogger {
  LogFunction _logFunction;

  BaseTransformLogger(this._logFunction);

  @override
  void info(String message, {AssetId asset, source_span.SourceSpan span}) {
    _logFunction(asset, LogLevel.INFO, message, span);
  }

  @override
  void fine(String message, {AssetId asset, source_span.SourceSpan span}) {
    _logFunction(asset, LogLevel.FINE, message, span);
  }

  @override
  void warning(String message, {AssetId asset, source_span.SourceSpan span}) {
    _logFunction(asset, LogLevel.WARNING, message, span);
  }

  @override
  void error(String message, {AssetId asset, source_span.SourceSpan span}) {
    _logFunction(asset, LogLevel.ERROR, message, span);
  }
}

/// One message logged during a transform.
class LogEntry {
  /// The transform that logged the message.
  //final TransformInfo transform;
  final Transform transform;

  /// The asset that the message is associated with.
  final AssetId assetId;

  final LogLevel level;
  final String message;

  /// The location that the message pertains to or null if not associated with
  /// a [SourceSpan].
  final source_span.SourceSpan span;

  LogEntry(this.transform, this.assetId, this.level, this.message, this.span);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write('$assetId ${level} ${message}');
    if (span != null) {
      sb.write(' $span');
    }
    return sb.toString();
  }
}

//_addLog(assetId, level, message, span);
class MemoryLoggerFunction {
  Transform transform;
  final List<LogEntry> _logs = [];

  MemoryLoggerFunction(this.transform);
  _addLog(AssetId assetId, LogLevel level, String message,
      source_span.SourceSpan span) {
    _logs.add(new LogEntry(transform, assetId, level, message, span));
  }
}

class MemoryTransformLogger extends BaseTransformLogger {
  final List<LogEntry> logs = [];
  Transform transform;

  _addLog(AssetId assetId, LogLevel level, String message,
      source_span.SourceSpan span) {
    logs.add(new LogEntry(transform, assetId, level, message, span));
  }

  MemoryTransformLogger(this.transform) : super(null) {
    _logFunction = _addLog;
  }
}
