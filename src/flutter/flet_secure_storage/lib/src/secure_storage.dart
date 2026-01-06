import 'dart:convert';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorageService extends FletService {
  SecureStorageService({required super.control});

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
    final FlutterSecureStorage storage = FlutterSecureStorage(
      iOptions: iosOptions(jsonDecode(args["options"]["ios"])),
      aOptions: androidOptions(jsonDecode(args["options"]["android"])),
      lOptions: linuxOptions(jsonDecode(args["options"]["linux"])),
      wOptions: windowsOptions(jsonDecode(args["options"]["windows"])),
      webOptions: webOptions(jsonDecode(args["options"]["web"])),
      mOptions: macOptions(jsonDecode(args["options"]["macos"])),
    );
    switch (name) {
      case "set":
        return storage.write(key: args["key"]!, value: args["value"]!);
      case "get":
        return storage.read(key: args["key"]!);
      case "contains_key":
        return storage.containsKey(key: args["key"]!);
      case "get_keys":
        return storage.readAll();
      case "remove":
        return storage.delete(key: args["key"]!);
      case "clear":
        return storage.deleteAll();
      default:
        throw Exception("Unknown SecureStorage method: $name");
    }
  }

  IOSOptions iosOptions(Map<String, dynamic> args) {
    return IOSOptions(
      accountName: args["account_name"],
      groupId: args["group_id"],
      accessibility: args["accessibility"],
      synchronizable: args["synchronizable"],
      label: args["label"],
      description: args["description"],
      comment: args["comment"],
      isInvisible: args["is_invisible"],
      isNegative: args["is_negative"],
      creationDate: args["creation_date"],
      lastModifiedDate: args["last_modified_date"],
      resultLimit: args["result_limit"],
      shouldReturnPersistentReference: args["is_persistent"],
      authenticationUIBehavior: args["auth_ui_behavior"],
      accessControlFlags: args["access_control_flags"],
    );
  }

  MacOsOptions macOptions(Map<String, dynamic> args) {
    return MacOsOptions(
      accountName: args["account_name"],
      groupId: args["group_id"],
      accessibility: args["accessibility"],
      synchronizable: args["synchronizable"],
      label: args["label"],
      description: args["description"],
      comment: args["comment"],
      isInvisible: args["is_invisible"],
      isNegative: args["is_negative"],
      creationDate: args["creation_date"],
      lastModifiedDate: args["last_modified_date"],
      resultLimit: args["result_limit"],
      shouldReturnPersistentReference: args["is_persistent"],
      authenticationUIBehavior: args["auth_ui_behavior"],
      accessControlFlags: args["access_control_flags"],
      usesDataProtectionKeychain: args["uses_data_protection_keychain"]
    );
  }

  AndroidOptions androidOptions(Map<String, dynamic> args) {
    return AndroidOptions(
      resetOnError: args["reset_on_error"],
      migrateOnAlgorithmChange: args["migrate_on_algorithm_change"],
      enforceBiometrics: args["enforce_biometrics"],
      keyCipherAlgorithm: args["key_cipher_algorithm"],
      storageCipherAlgorithm: args["storage_cipher_algorithm"],
      sharedPreferencesName: args["shared_preferences_name"],
      preferencesKeyPrefix: args["preferences_key_prefix"],
      biometricPromptTitle: args["biometric_prompt_title"],
      biometricPromptSubtitle: args["biometric_prompt_subtitle"],
    );
  }

  LinuxOptions linuxOptions(Map<String, dynamic> args) {
    return LinuxOptions();
  }

  WindowsOptions windowsOptions(Map<String, dynamic> args) {
    return WindowsOptions(
      useBackwardCompatibility: args["use_backward_compatibility"],
    );
  }

  WebOptions webOptions(Map<String, dynamic> args) {
    return WebOptions(
      dbName: args["db_name"],
      publicKey: args["public_key"],
      wrapKey: args["wrap_key"],
      wrapKeyIv: args["wrap_key_iv"],
      useSessionStorage: args["use_session_storage"],
    );
  }

  @override
  void dispose() {
    debugPrint("SecureStorageService(${control.id}).dispose()");
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }
}
