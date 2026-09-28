import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

String symbolId(Element element) {
  final names = <String>[];
  Element? current = element;
  while (current != null && current is! LibraryElement) {
    names.insert(0, current.name ?? '');
    current = current.enclosingElement;
  }
  return '${element.library?.uri}#${names.join('.')}';
}

Map<String, Object?> typeFact(DartType type) => {
  'display': type.getDisplayString(),
  'nullable': type.nullabilitySuffix.name == 'question',
  'resolution': type is DynamicType
      ? 'dynamic'
      : type is InvalidType
      ? 'unresolved'
      : 'resolved',
  if (type.element != null) 'symbolId': symbolId(type.element!),
  if (type is ParameterizedType)
    'arguments': type.typeArguments.map(typeFact).toList(),
  if (type is FunctionType) 'returnType': typeFact(type.returnType),
};
