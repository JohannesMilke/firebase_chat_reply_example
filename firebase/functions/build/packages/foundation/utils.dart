class Utils {
  static DateTime toDateTime(value) {
    if (value == null) return null;

    try {
      // call in flutter [Timestamp.toDate()]
      return value.toDate();
    } catch (e) {
      // call in functions [Timestamp.toDateTime()]
      return value.toDateTime();
    }
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
