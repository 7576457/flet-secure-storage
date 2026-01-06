from dataclasses import field
from typing import Any

from flet.controls.base_control import control
from flet.controls.services.service import Service
from options import (
    AndroidOptions,
    IOSOptions,
    LinuxOptions,
    MacOsOptions,
    WebOptions,
    WindowsOptions,
)


@control("SecureStorage")
class SecureStorage(Service):
    ios_options: IOSOptions = field(default_factory=IOSOptions)
    android_options: AndroidOptions = field(default_factory=AndroidOptions)
    windows_options: WindowsOptions = field(default_factory=WindowsOptions)
    linux_options: LinuxOptions = field(default_factory=LinuxOptions)
    macos_options: MacOsOptions = field(default_factory=MacOsOptions)
    web_options: WebOptions = field(default_factory=WebOptions)

    async def set(self, key: str, value: Any) -> bool:
        if value is None:
            raise ValueError("value can't be None")
        return await self._invoke_method("set", {"key": key, "value": value})

    async def get(self, key: str):
        return await self._invoke_method("get", {"key": key})

    async def contains_key(self, key: str) -> bool:
        return await self._invoke_method("contains_key", {"key": key})

    async def remove(self, key: str) -> bool:
        return await self._invoke_method("remove", {"key": key})

    async def get_keys(self, key_prefix: str) -> list[str]:
        return await self._invoke_method("get_keys", {"key_prefix": key_prefix})

    async def clear(self) -> bool:
        return await self._invoke_method("clear")

    async def _invoke_method(
        self,
        method_name: str,
        arguments: dict[str, Any] = None,
        timeout: float | None = None,
    ) -> dict:
        if arguments is None:
            arguments = {}
        arguments["options"] = {
            "android": self.android_options.json,
            "ios": self.ios_options.json,
            "linux": self.linux_options.json,
            "macos": self.macos_options.json,
            "web": self.web_options.json,
            "windows": self.windows_options.json,
        }
        await super()._invoke_method(method_name, arguments, timeout)
