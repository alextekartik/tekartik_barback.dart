library tekartik_uppercase_transformer;

import 'package:tekartik_barback/transformer_barback.dart';
import 'uppercase_transformer_impl.dart' as impl;

class UppercaseTransformer extends BarbackTransformer {
  //final BarbackSettings settings;
  final impl.UppercaseTransformer transformer;

  UppercaseTransformer.asPlugin([BarbackSettings settings])
      : transformer = new impl.UppercaseTransformer.asPlugin(settings);
}
