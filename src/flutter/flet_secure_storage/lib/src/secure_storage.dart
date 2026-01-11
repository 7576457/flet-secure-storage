import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'utils/secure_storage.dart';


class SecureStorageService extends FletService {
  SecureStorageService({required super.control});
  late FlutterSecureStorage storage;
  IOSOptions iosOptions = IOSOptions.defaultOptions;
  AndroidOptions androidOptions = AndroidOptions.defaultOptions;
  LinuxOptions linuxOptions = LinuxOptions.defaultOptions;
  WindowsOptions windowsOptions = WindowsOptions.defaultOptions;
  WebOptions webOptions = WebOptions.defaultOptions;
  MacOsOptions macOsOptions = MacOsOptions.defaultOptions;  

  @override
  void init() {
    super.init();
    debugPrint("SecureStorageService(${control.id}).init: ${control.properties}");
    control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void update() {
    debugPrint("SecureStorageService(${control.id}).update: ${control.properties}");
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    storage = FlutterSecureStorage(
      lOptions: linuxOptions,
      aOptions: parseAndroidOptions(control.get<Map>("android_options"), androidOptions)!,
      wOptions: parseWindowsOptions(control.get<Map>("windows_options"), windowsOptions)!,
      mOptions: parseMacOptions(control.get<Map>("macos_options"), macOsOptions)!,
      iOptions: parseIosOptions(control.get<Map>("ios_options"), iosOptions)!,
      webOptions: parseWebOptions(control.get<Map>("web_options"), webOptions)!,
    );
    switch (name) {
      case "set":
        return await storage.write(
          key: args["key"]!,
          value: args["value"]!,
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      case "get":
        return await storage.read(
          key: args["key"]!,
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      case "get_all":
        return await storage.readAll(
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      case "contains_key":
        return await storage.containsKey(
          key: args["key"]!,
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      case "remove":
        return await storage.delete(
          key: args["key"]!,
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      case "clear":
        return await storage.deleteAll(
          aOptions: parseAndroidOptions(args?["android"], storage.aOptions)!,
          iOptions: parseIosOptions(args?["ios"], storage.iOptions)!,
          lOptions: storage.lOptions,
          wOptions: parseWindowsOptions(args?["windows"], storage.wOptions)!,
          webOptions: parseWebOptions(args?["web"], storage.webOptions)!,
          mOptions: parseMacOptions(args?["macos"], storage.mOptions as MacOsOptions)!,
        );
      default:
        throw Exception("Unknown SecureStorage method: $name");
    }
  }

  @override
  void dispose() {
    debugPrint("SecureStorageService(${control.id}).dispose()");
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }
}
