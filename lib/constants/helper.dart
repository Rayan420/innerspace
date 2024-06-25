class BackendUrls {
  static const String developmentBaseUrl =
      'http://10.0.2.2:8000'; // Example local backend URL
  static const String productionBaseUrl =
      'https://production-backend.com'; // Example production backend URL

  static String replaceFromLocalhost(String url) {
    if (url.contains('localhost')) {
      return url.replaceFirst('localhost', '10.0.2.2');
    }
    return url;
  }

  static replaceToLocalhost(String url) {
    if (url.contains('10.0.2.2')) {
      return url.replaceFirst('10.0.2.2', 'localhost');
    }
    return url;
  }
}
