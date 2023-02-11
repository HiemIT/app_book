enum Flavor {
  staging,
  production,
  mock,
}

class ConfigEnv {
  static Flavor? appFlavor;

  static String getDomainAPI() {
    switch (appFlavor) {
      case Flavor.staging:
        return 'http://192.168.101.27:8000';
      case Flavor.mock:
        return 'http://192.168.101.27:8000';
      default:
        return 'http://192.168.101.27:8000';
    }
  }
}
