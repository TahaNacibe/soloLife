String formatNumber(int number) {
  if (number >= 1000000) {
    double result = number / 1000000;
    if (result.floor() == result) {
      return '${result.toInt()}m';
    } else {
      return '${result.toStringAsFixed(1)}m';
    }
  } else if (number >= 1000) {
    double result = number / 1000;
    if (result.floor() == result) {
      return '${result.toInt()}k';
    } else {
      return '${result.toStringAsFixed(1)}k';
    }
  } else {
    return number.toString();
  }
}
