/// Provides utility functions.

String formatDistance(double dist) {
  String unit;
  if (dist >= 1000) {
    unit = 'km';
  } else if (dist >= 1) {
    unit = 'm';
  } else {
    unit = 'cm';
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
