# Flet Secure Storage

[![en](https://img.shields.io/badge/lang-en-red.svg)](README.md)
[![ru](https://img.shields.io/badge/lang-ru-blue.svg)](docs/README.ru.md)

Extension for [Flet](https://flet.dev) that provides secure data storage across all platforms via [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).

## Project Structure
```
flet_secure_storage/
├── enums.py           # Enums for cryptography and access configuration
├── options.py         # Platform-specific option classes
└── secure_storage.py  # Main SecureStorage class
```

## How it works

### 1. **enums.py** - Configuration Constants

Defines enums for security settings:

- `KeychainAccessibility` - when data is accessible (iOS/macOS)
- `AccessControlFlag` - access requirements (biometrics, passcode, etc.)
- `KeyCipherAlgorithm` - key encryption algorithms (Android)
- `StorageCipherAlgorithm` - storage encryption algorithms (Android)

### 2. **options.py** - Platform Options

Platform-specific configuration classes:

- `AndroidOptions` - encryption algorithms, biometric settings
- `IOSOptions` / `MacOsOptions` - keychain settings, accessibility rules
- `WebOptions` - IndexedDB configuration
- `WindowsOptions` - Windows credential manager settings
- `LinuxOptions` - libsecret configuration

Each class:
- Is a frozen dataclass with slots for efficiency
- Inherits from `Options` base class
- Has `.to_json()` method for serialization to Dart/Flutter
- Automatically serializes enums and datetime objects

### 3. **secure_storage.py** - Main API

The `SecureStorage` service provides:

**Methods:**
- `await set(key, value)` - store encrypted value
- `await get(key)` - retrieve value
- `await contains_key(key)` - check if key exists
- `await remove(key)` - delete key
- `await get_keys(prefix)` - list keys by prefix
- `await clear()` - remove all data

**Platform Options:**
Each method call automatically includes platform-specific options:
```python
storage = SecureStorage(
    android_options=AndroidOptions(enforce_biometrics=True),
    ios_options=IOSOptions(accessibility=KeychainAccessibility.FIRST_UNLOCK)
)
```

## Usage Example
```python
import flet as ft
from flet_secure_storage import SecureStorage, AndroidOptions, IOSOptions

async def main(page: ft.Page):
    # Initialize with custom options
    storage = SecureStorage(
        android_options=AndroidOptions(
            enforce_biometrics=True,
            biometric_prompt_title="Unlock App"
        ),
        ios_options=IOSOptions(
            accessibility=KeychainAccessibility.FIRST_UNLOCK
        )
    )
    
    # Store data
    await storage.set("api_token", "secret_value")
    
    # Retrieve data
    token = await storage.get("api_token")
    
    # Check existence
    exists = await storage.contains_key("api_token")
    
    # Remove data
    await storage.remove("api_token")

ft.app(target=main)
```