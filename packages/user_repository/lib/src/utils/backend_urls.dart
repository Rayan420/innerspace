class BackendUrls {
  static const String developmentBaseUrl =
      'http://10.0.2.2:8000'; // Example local backend URL
  static const String productionBaseUrl =
      'https://production-backend.com'; // Example production backend URL

  static String replaceLocalhost(String url) {
    if (url.contains('localhost')) {
      return url.replaceFirst('localhost', '10.0.2.2');
    }
    return url;
  }
}
