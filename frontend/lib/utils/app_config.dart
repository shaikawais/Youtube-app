class AppConfig {
  /// Android Emulator
  static const String emulatorHost = "http://10.0.2.2:9000";

  /// Replace with your machine's IP
  static const String deviceHost = "http://192.168.3.157:9000";

  /// Change to deviceHost if testing on physical device
  static const String activeHost = emulatorHost;
}
