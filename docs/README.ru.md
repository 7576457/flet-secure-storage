# Flet Secure Storage

[![en](https://img.shields.io/badge/lang-en-blue.svg)](README.md)
[![ru](https://img.shields.io/badge/lang-ru-red.svg)](docs/README.ru.md)

Расширение для [Flet](https://flet.dev), обеспечивающее безопасное хранение данных на всех платформах через [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).

## Структура проекта

```
flet_secure_storage/
├── enums.py           # Enum'ы для настройки криптографии и доступа
├── options.py         # Классы опций для каждой платформы
└── secure_storage.py  # Главный класс SecureStorage
```

## Как это работает

### 1. **enums.py** - Константы для конфигурации

Определяет enum'ы для настройки безопасности:

- `KeychainAccessibility` - когда данные доступны (iOS/macOS)
- `AccessControlFlag` - требования для доступа (биометрия, пароль и т.д.)
- `KeyCipherAlgorithm` - алгоритмы шифрования ключей (Android)
- `StorageCipherAlgorithm` - алгоритмы шифрования данных (Android)

### 2. **options.py** - Опции для платформ

Классы конфигурации для каждой платформы:

- `AndroidOptions` - алгоритмы шифрования, настройки биометрии
- `IOSOptions` / `MacOsOptions` - настройки keychain, правила доступа
- `WebOptions` - конфигурация IndexedDB
- `WindowsOptions` - настройки Windows credential manager
- `LinuxOptions` - конфигурация libsecret

Каждый класс:
- Является frozen dataclass со slots для эффективности
- Наследуется от базового класса `Options`
- Имеет метод `.to_json()` для сериализации в Dart/Flutter
- Автоматически сериализует enum'ы и datetime объекты

### 3. **secure_storage.py** - Основное API

Сервис `SecureStorage` предоставляет:

**Методы:**
- `await set(key, value)` - сохранить зашифрованное значение
- `await get(key)` - получить значение
- `await contains_key(key)` - проверить существование ключа
- `await remove(key)` - удалить ключ
- `await get_keys(prefix)` - получить список ключей по префиксу
- `await clear()` - удалить все данные

**Опции платформ:**
Каждый вызов метода автоматически включает опции для конкретной платформы:
```python
storage = SecureStorage(
    android_options=AndroidOptions(enforce_biometrics=True),
    ios_options=IOSOptions(accessibility=KeychainAccessibility.FIRST_UNLOCK)
)
```

## Пример использования

```python
import flet as ft
from flet_secure_storage import SecureStorage, AndroidOptions, IOSOptions

async def main(page: ft.Page):
    # Инициализация с кастомными опциями
    storage = SecureStorage(
        android_options=AndroidOptions(
            enforce_biometrics=True,
            biometric_prompt_title="Разблокируйте приложение"
        ),
        ios_options=IOSOptions(
            accessibility=KeychainAccessibility.FIRST_UNLOCK
        )
    )
    
    # Сохранить данные
    await storage.set("api_token", "secret_value")
    
    # Получить данные
    token = await storage.get("api_token")
    
    # Проверить существование
    exists = await storage.contains_key("api_token")
    
    # Удалить данные
    await storage.remove("api_token")

ft.app(target=main)
```
