/// Converts the [input] into the value used by [SMUTextSearcher]
typedef SMUTextConverter<T> = Iterable<String> Function(T input);

/// Default text converter, just converts the object to string.
Iterable<String> defaultSMUTextConverter(dynamic val) => {'$val'};
