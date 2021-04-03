
class ApiUtil {
  static Uri baseUrl(String endpoint) => Uri.parse("http://192.168.1.4/api/notes/$endpoint");
}