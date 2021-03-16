/// Provides utility functions.

String formatDistance(double dist) {
  String unit;
  if (dist >= 1000) {
    unit = 'km';
  } else {
    unit = 'm';
  }
  return '${dist.toStringAsFixed(2)} $unit';
}

String pluralise(String stuff, int n, {String? plural}) {
  if (plural == null) {
    plural = '${stuff}s';
  }
  return n == 1 ? stuff : plural;
}

String enumName(String? value) {
  if (value == null) {
    return 'Indifferent';
  }
  return value.split('.').last;
}

String? doubleValidator(String? value) {
  if (value == null || double.tryParse(value) == null) {
    return 'Invalid number.';
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'You must supply a name.';
  }
}

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
