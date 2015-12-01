library transformer_utils;

import 'dart:async';

import 'package:source_span/source_span.dart' as source_span;
import 'package:barback/barback.dart' as brbck;
export 'transformer.dart' hide TransformerContext, Transformer, Transform;
import 'transformer.dart' hide Asset, Transformer, Transform;
import 'transformer.dart' as common;

import 'dart:convert';

// for declaration
abstract class BarbackTransformer extends brbck.Transformer {
//brbck.BarbackSettings  BarbackS
  //brbck.DeclaringTransformer _;
  // to override
  common.Transformer get transformer;

  apply(brbck.Transform transform) =>
      transformer.apply(new BarbackTransform.wrap(transform));

  String get allowedExtensions => transformer.allowedExtensions;

  isPrimary(AssetId id) => transformer.isPrimary(id);
}

/**
 * Used in transformers
 */
class BarbackTransform implements common.Transform {
  brbck.Transform transform;
  BarbackTransform.wrap(this.transform);

  @override
  AssetId get primaryInputId => transform.primaryInput.id;

  // add the content in a given asset
  @override
  AssetId addOutputFromString(AssetId id, String content, {Encoding encoding}) {
    transform.addOutput(new brbck.Asset.fromString(id, content));
    return id;
  }

  @override
  Future<String> readPrimaryInputAssetAsString({Encoding encoding}) =>
      transform.primaryInput.readAsString(encoding: encoding);

  @override
  Future<String> readInputAsString(AssetId id, {Encoding encoding}) {
    return transform.readInputAsString(id, encoding: encoding);
  }

  @override
  Future<bool> hasInput(AssetId id) => transform.hasInput(id);

  @override
  brbck.TransformLogger get logger => transform.logger;

  @override
  void consumePrimary() => transform.consumePrimary();
}

/// Object used to report warnings and errors encountered while running a
/// transformer.
class BarbackTransformLogger implements TransformLogger {
  brbck.TransformLogger _impl;

  BarbackTransformLogger(this._impl);

  @override
  void info(String message, {AssetId asset, source_span.SourceSpan span}) =>
      _impl.info(message, asset: asset, span: span);

  @override
  void fine(String message, {AssetId asset, source_span.SourceSpan span}) =>
      _impl.fine(message, asset: asset, span: span);

  @override
  void warning(String message, {AssetId asset, source_span.SourceSpan span}) =>
      _impl.warning(message, asset: asset, span: span);

  @override
  void error(String message, {AssetId asset, source_span.SourceSpan span}) =>
      _impl.error(message, asset: asset, span: span);
}
