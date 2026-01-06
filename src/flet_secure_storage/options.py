import json
from dataclasses import dataclass, field, asdict
from datetime import datetime
from typing import Any

from enums import (
    AccessControlFlag,
    KeychainAccessibility,
    KeyCipherAlgorithm,
    StorageCipherAlgorithm,
)


class Options:
    @property
    def json(self) -> str:
        return self.to_json()

    def to_json(self) -> str:
        return self._to_json_default()

    def _to_json_default(self) -> str:
        data = asdict(self)
        serialized = {k: self._serialize_value(v) for k, v in data.items()}
        return json.dumps(serialized)

    def _serialize_value(self, obj: Any) -> Any:
        if isinstance(obj, datetime):
            return obj.isoformat()
        elif isinstance(
            obj,
            (
                KeychainAccessibility,
                KeyCipherAlgorithm,
                StorageCipherAlgorithm,
                AccessControlFlag,
            ),
        ):
            return obj.value
        elif isinstance(obj, list):
            return [self._serialize_value(item) for item in obj]
        elif obj is None:
            return None
        return obj


@dataclass(frozen=True, slots=True)
class AndroidOptions(Options):
    reset_on_error: bool = True
    migrate_on_algorithm_change: bool = True
    enforce_biometrics: bool = False
    key_cipher_algorithm: KeyCipherAlgorithm = KeyCipherAlgorithm.RSA_ECB_OAEP
    storage_cipher_algorithm: StorageCipherAlgorithm = StorageCipherAlgorithm.AES_GCM
    shared_preferences_name: str | None = None
    preferences_key_prefix: str | None = None
    biometric_prompt_title: str = "Authenticate to access"
    biometric_prompt_subtitle: str = "Use biometrics or device credentials"


@dataclass(frozen=True, slots=True)
class AppleOptions(Options):
    account_name: str | None = "flutter_secure_storage_service"
    group_id: str | None = None
    accessibility: KeychainAccessibility | None = KeychainAccessibility.UNLOCKED
    synchronizable: bool = False
    label: str | None = None
    description: str | None = None
    comment: str | None = None
    is_invisible: bool | None = None
    is_negative: bool | None = None
    creation_date: datetime | None = None
    last_modified_date: datetime | None = None
    result_limit: int | None = None
    is_persistent: bool | None = None
    auth_ui_behavior: str | None = None
    access_control_flags: list[AccessControlFlag] = field(default_factory=list)


@dataclass(frozen=True, slots=True)
class IOSOptions(AppleOptions): ...


@dataclass(frozen=True, slots=True)
class MacOsOptions(AppleOptions):
    uses_data_protection_keychain: bool = True


@dataclass(frozen=True, slots=True)
class WebOptions(Options):
    db_name: str = "FlutterEncryptedStorage"
    public_key: str = "FlutterSecureStorage"
    wrap_key: str = ""
    wrap_key_iv: str = ""
    use_session_storage: bool = False


@dataclass(frozen=True, slots=True)
class WindowsOptions(Options):
    use_backward_compatibility: bool = False


@dataclass(frozen=True, slots=True)
class LinuxOptions(Options): ...
