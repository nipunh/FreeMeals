class EnvironmentConfig {
  //USE 'prod' for production and 'dev' for development
  static const APP_MODE =
      String.fromEnvironment('APP_MODE', defaultValue: 'test');
}
