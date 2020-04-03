String distanceToString(num metres) {
  if (metres > 1000) {
    return '${(metres / 1000).toStringAsFixed(2)} km';
  } else {
    return '$metres m';
  }
}
