// quick function for number to string for the budget manager card and screen
String formatNumber(int number) {
  
  //took the number if it reach the million here
  if (number >= 1000000) {
    double result = number / 1000000;
    if (result.floor() == result) {
      // getting closer to int as much as possible
      return '${result.toInt()}m';
    } else {
      // sent it as double
      return '${result.toStringAsFixed(1)}m';
    }

    // less than million but more than thousand
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
