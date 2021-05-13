/// Provides utility functions.

String formatDistance(double dist) {
  String unit;
  if (dist >= 1000) {
    unit = 'km';
    dist /= 1000;
  } else {
    unit = 'm';
  }
  return '${dist.toStringAsFixed(2)} $unit';
}

/// Return a pluralised version of a string.
///
/// If for example you have the word "coordinate", but you have more than 1
/// coordinate, the word "coordinates" should be used.
String pluralise(String stuff, int n, {String? plural}) {
  if (plural == null) {
    plural = '${stuff}s';
  }
  return n == 1 ? stuff : plural;
}

/// Get the name of an enum value.
String enumName(String? value) {
  if (value == null) {
    return 'Indifferent';
  }
  return value.split('.').last;
}

/// Return a message if [value] is not a valid double.
String? doubleValidator(String? value) {
  if (value == null || double.tryParse(value) == null) {
    return 'Invalid number.';
  }
}

/// Return a message if [value] is empty.
String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'You must supply a name.';
  }
}

/// Return a string representing [angle].
String formatBearing(double angle) {
  const List<String> directions = <String>[
    'north',
    'northeast',
    'east',
    'southeast',
    'south',
    'southwest',
    'west',
    'northwest'
  ];
  final int index = (((angle %= 360) < 0 ? angle + 360 : angle) / 45).round() %
      directions.length;
  return '${directions[index]} (${angle.floor()} °)';
}
