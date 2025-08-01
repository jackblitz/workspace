# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This becomes the BUILD file for @local_config_cc// under Windows.

load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_cc//cc/toolchains:cc_toolchain.bzl", "cc_toolchain")
load("@rules_cc//cc/toolchains:cc_toolchain_suite.bzl", "cc_toolchain_suite")
load(":windows_cc_toolchain_config.bzl", "cc_toolchain_config")
load(":armeabi_cc_toolchain_config.bzl", "armeabi_cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_library(name = "empty_lib")

# Label flag for extra libraries to be linked into every binary.
# TODO(bazel-team): Support passing flag multiple times to build a list.
label_flag(
    name = "link_extra_libs",
    build_setting_default = ":empty_lib",
)

# The final extra library to be linked into every binary target. This collects
# the above flag, but may also include more libraries depending on config.
cc_library(
    name = "link_extra_lib",
    deps = [
        ":link_extra_libs",
    ],
)

cc_library(
    name = "malloc",
)

filegroup(
    name = "empty",
    srcs = [],
)

filegroup(
    name = "mingw_compiler_files",
    srcs = [":builtin_include_directory_paths_mingw"]
)

filegroup(
    name = "clangcl_compiler_files",
    srcs = [":builtin_include_directory_paths_clangcl"]
)

filegroup(
    name = "msvc_compiler_files",
    srcs = [
        ":builtin_include_directory_paths_msvc",
        "msvc_deps_scanner_wrapper_x86.bat",
        "msvc_deps_scanner_wrapper_x64.bat",
        "msvc_deps_scanner_wrapper_arm.bat",
        "msvc_deps_scanner_wrapper_arm64.bat",
    ]
)

# Hardcoded toolchain, legacy behaviour.
cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "armeabi-v7a|compiler": ":cc-compiler-armeabi-v7a",
        "x64_windows|msvc-cl": ":cc-compiler-x64_windows",
        "x64_x86_windows|msvc-cl": ":cc-compiler-x64_x86_windows",
        "x64_arm_windows|msvc-cl": ":cc-compiler-x64_arm_windows",
        "x64_arm64_windows|msvc-cl": ":cc-compiler-arm64_windows",
        "arm64_windows|msvc-cl": ":cc-compiler-arm64_windows",
        "x64_windows|msys-gcc": ":cc-compiler-x64_windows_msys",
        "x64_x86_windows|msys-gcc": ":cc-compiler-x64_x86_windows_msys",
        "x64_windows|mingw-gcc": ":cc-compiler-x64_windows_mingw",
        "x64_x86_windows|mingw-gcc": ":cc-compiler-x64_x86_windows_mingw",
        "x64_windows|clang-cl": ":cc-compiler-x64_windows-clang-cl",
        "x64_windows_msys": ":cc-compiler-x64_windows_msys",
        "x64_windows": ":cc-compiler-x64_windows",
        "x64_x86_windows": ":cc-compiler-x64_x86_windows",
        "x64_arm_windows": ":cc-compiler-x64_arm_windows",
        "x64_arm64_windows": ":cc-compiler-arm64_windows",
        "arm64_windows": ":cc-compiler-arm64_windows",
        "x64_arm64_windows|clang-cl": ":cc-compiler-arm64_windows-clang-cl",
        "arm64_windows|clang-cl": ":cc-compiler-arm64_windows-clang-cl",
        "armeabi-v7a": ":cc-compiler-armeabi-v7a",
    },
)

cc_toolchain(
    name = "cc-compiler-x64_windows_msys",
    toolchain_identifier = "msys_x64",
    toolchain_config = ":msys_x64",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":mingw_compiler_files",
    compiler_files = ":mingw_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msys_x64",
    cpu = "x64_windows",
    compiler = "msys-gcc",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msys",
    abi_version = "local",
    abi_libc_version = "local",
    cxx_builtin_include_directories = [],
    tool_paths = {"ar": "msys_gcc_installation_error.bat",
        "cpp": "msys_gcc_installation_error.bat",
        "dwp": "msys_gcc_installation_error.bat",
        "gcc": "msys_gcc_installation_error.bat",
        "gcov": "msys_gcc_installation_error.bat",
        "ld": "msys_gcc_installation_error.bat",
        "nm": "msys_gcc_installation_error.bat",
        "objcopy": "msys_gcc_installation_error.bat",
        "objdump": "msys_gcc_installation_error.bat",
        "strip": "msys_gcc_installation_error.bat"},
    tool_bin_path = "usr/bin",
)

toolchain(
    name = "cc-toolchain-x64_windows_msys",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:msys",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_windows_msys",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_x86_windows_msys",
    toolchain_identifier = "msys_x64_x86",
    toolchain_config = ":msys_x64_x86",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":mingw_compiler_files",
    compiler_files = ":mingw_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msys_x64_x86",
    cpu = "x64_x86_windows",
    compiler = "msys-gcc",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msys",
    abi_version = "local",
    abi_libc_version = "local",
    cxx_builtin_include_directories = [],
    tool_paths = {"ar": "msys_gcc_installation_error.bat",
        "cpp": "msys_gcc_installation_error.bat",
        "dwp": "msys_gcc_installation_error.bat",
        "gcc": "msys_gcc_installation_error.bat",
        "gcov": "msys_gcc_installation_error.bat",
        "ld": "msys_gcc_installation_error.bat",
        "nm": "msys_gcc_installation_error.bat",
        "objcopy": "msys_gcc_installation_error.bat",
        "objdump": "msys_gcc_installation_error.bat",
        "strip": "msys_gcc_installation_error.bat"},
    tool_bin_path = "usr/bin",
    default_compile_flags = ["-m32"],
    default_link_flags = ["-m32"],
)

toolchain(
    name = "cc-toolchain-x64_x86_windows_msys",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:msys",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_32",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_x86_windows_msys",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_windows_mingw",
    toolchain_identifier = "msys_x64_mingw",
    toolchain_config = ":msys_x64_mingw",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":mingw_compiler_files",
    compiler_files = ":mingw_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)

cc_toolchain_config(
    name = "msys_x64_mingw",
    cpu = "x64_windows",
    compiler = "mingw-gcc",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "mingw",
    abi_version = "local",
    abi_libc_version = "local",
    tool_bin_path = "mingw64/bin",
    cxx_builtin_include_directories = [],
    tool_paths = {"ar": "msys_gcc_installation_error.bat",
        "cpp": "msys_gcc_installation_error.bat",
        "dwp": "msys_gcc_installation_error.bat",
        "gcc": "msys_gcc_installation_error.bat",
        "gcov": "msys_gcc_installation_error.bat",
        "ld": "msys_gcc_installation_error.bat",
        "nm": "msys_gcc_installation_error.bat",
        "objcopy": "msys_gcc_installation_error.bat",
        "objdump": "msys_gcc_installation_error.bat",
        "strip": "msys_gcc_installation_error.bat"},
)

toolchain(
    name = "cc-toolchain-x64_windows_mingw",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:mingw",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_windows_mingw",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_x86_windows_mingw",
    toolchain_identifier = "msys_x64_x86_mingw",
    toolchain_config = ":msys_x64_x86_mingw",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":mingw_compiler_files",
    compiler_files = ":mingw_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)

cc_toolchain_config(
    name = "msys_x64_x86_mingw",
    cpu = "x64_x86_windows",
    compiler = "mingw-gcc",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "mingw",
    abi_version = "local",
    abi_libc_version = "local",
    tool_bin_path = "mingw64/bin",
    cxx_builtin_include_directories = [],
    tool_paths = {"ar": "msys_gcc_installation_error.bat",
        "cpp": "msys_gcc_installation_error.bat",
        "dwp": "msys_gcc_installation_error.bat",
        "gcc": "msys_gcc_installation_error.bat",
        "gcov": "msys_gcc_installation_error.bat",
        "ld": "msys_gcc_installation_error.bat",
        "nm": "msys_gcc_installation_error.bat",
        "objcopy": "msys_gcc_installation_error.bat",
        "objdump": "msys_gcc_installation_error.bat",
        "strip": "msys_gcc_installation_error.bat"},
    default_compile_flags = ["-m32"],
    default_link_flags = ["-m32"],
)

toolchain(
    name = "cc-toolchain-x64_x86_windows_mingw",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:mingw",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_32",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_x86_windows_mingw",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_windows",
    toolchain_identifier = "msvc_x64",
    toolchain_config = ":msvc_x64",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":msvc_compiler_files",
    compiler_files = ":msvc_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msvc_x64",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "msvc_x64",
    msvc_env_tmp = "C:\\Users\\luke\\AppData\\Local\\Temp",
    msvc_env_path = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\bin\\HostX64\\x64;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\VC\\VCPackages;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\TestWindow;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\TeamFoundation\\Team Explorer;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\MSBuild\\Current\\bin\\Roslyn;C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v10.0A\\bin\\NETFX 4.8 Tools\\x64\\;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Team Tools\\DiagnosticsHub\\Collector;C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.26100.0\\\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\bin\\\\x64;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\\\MSBuild\\Current\\Bin\\amd64;C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\;;C:\\WINDOWS\\system32;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\CMake\\CMake\\bin;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\CMake\\Ninja;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\VC\\Linux\\bin\\ConnectionManagerExe;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\vcpkg",
    msvc_env_include = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\include;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\VS\\include;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.26100.0\\ucrt;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\um;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\shared;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\winrt;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\cppwinrt;C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\include\\um",
    msvc_env_lib = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\lib\\x64;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\lib\\x64;C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\lib\\um\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\lib\\10.0.26100.0\\ucrt\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\\\lib\\10.0.26100.0\\\\um\\x64",
    msvc_cl_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/cl.exe",
    msvc_ml_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/ml64.exe",
    msvc_link_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/link.exe",
    msvc_lib_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/lib.exe",
    cxx_builtin_include_directories = [        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include",
        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\include",
        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\VS\\include",
        "C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.26100.0\\ucrt",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\um",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\shared",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\winrt",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\cppwinrt",
        "C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\include\\um"],
    tool_paths = {
        "ar": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/lib.exe",
        "ml": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/ml64.exe",
        "cpp": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/cl.exe",
        "gcc": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/cl.exe",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/link.exe",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
        "dumpbin": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x64/dumpbin.exe",
        "cpp-module-deps-scanner": "msvc_deps_scanner_wrapper_x64.bat",
    },
    archiver_flags = ["/MACHINE:X64"],
    default_link_flags = ["/MACHINE:X64"],
    dbg_mode_debug_flag = "/DEBUG:FULL",
    fastbuild_mode_debug_flag = "/DEBUG:FASTLINK",
    supports_parse_showincludes = True,
)

toolchain(
    name = "cc-toolchain-x64_windows",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_windows",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_x86_windows",
    toolchain_identifier = "msvc_x64_x86",
    toolchain_config = ":msvc_x64_x86",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":msvc_compiler_files",
    compiler_files = ":msvc_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msvc_x64_x86",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "msvc_x64_x86",
    msvc_env_tmp = "C:\\Users\\luke\\AppData\\Local\\Temp",
    msvc_env_path = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\bin\\HostX64\\x86;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\bin\\HostX64\\x64;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\VC\\VCPackages;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\TestWindow;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\TeamFoundation\\Team Explorer;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\MSBuild\\Current\\bin\\Roslyn;C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v10.0A\\bin\\NETFX 4.8 Tools\\x64\\;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Team Tools\\DiagnosticsHub\\Collector;C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.26100.0\\\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\bin\\\\x64;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\\\MSBuild\\Current\\Bin\\amd64;C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\;;C:\\WINDOWS\\system32;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\CMake\\CMake\\bin;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\CommonExtensions\\Microsoft\\CMake\\Ninja;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\VC\\Linux\\bin\\ConnectionManagerExe;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\vcpkg",
    msvc_env_include = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\include;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\VS\\include;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.26100.0\\ucrt;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\um;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\shared;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\winrt;C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\cppwinrt;C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\include\\um",
    msvc_env_lib = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\lib\\x86;C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\lib\\x86;C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\lib\\um\\x86;C:\\Program Files (x86)\\Windows Kits\\10\\lib\\10.0.26100.0\\ucrt\\x86;C:\\Program Files (x86)\\Windows Kits\\10\\\\lib\\10.0.26100.0\\\\um\\x86",
    msvc_cl_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/cl.exe",
    msvc_ml_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/ml.exe",
    msvc_link_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/link.exe",
    msvc_lib_path = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/lib.exe",
    cxx_builtin_include_directories = [        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include",
        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\ATLMFC\\include",
        "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\VS\\include",
        "C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.26100.0\\ucrt",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\um",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\shared",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\winrt",
        "C:\\Program Files (x86)\\Windows Kits\\10\\\\include\\10.0.26100.0\\\\cppwinrt",
        "C:\\Program Files (x86)\\Windows Kits\\NETFXSDK\\4.8\\include\\um"],
    tool_paths = {
        "ar": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/lib.exe",
        "ml": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/ml.exe",
        "cpp": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/cl.exe",
        "gcc": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/cl.exe",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/link.exe",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
        "dumpbin": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX64/x86/dumpbin.exe",
        "cpp-module-deps-scanner": "msvc_deps_scanner_wrapper_x86.bat",
    },
    archiver_flags = ["/MACHINE:X86"],
    default_link_flags = ["/MACHINE:X86"],
    dbg_mode_debug_flag = "/DEBUG:FULL",
    fastbuild_mode_debug_flag = "/DEBUG:FASTLINK",
    supports_parse_showincludes = True,
)

toolchain(
    name = "cc-toolchain-x64_x86_windows",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_32",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_x86_windows",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-x64_arm_windows",
    toolchain_identifier = "msvc_x64_arm",
    toolchain_config = ":msvc_x64_arm",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":msvc_compiler_files",
    compiler_files = ":msvc_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msvc_x64_arm",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "msvc_x64_arm",
    msvc_env_tmp = "msvc_not_found",
    msvc_env_path = "msvc_not_found",
    msvc_env_include = "msvc_not_found",
    msvc_env_lib = "msvc_not_found",
    msvc_cl_path = "vc_installation_error_arm.bat",
    msvc_ml_path = "vc_installation_error_arm.bat",
    msvc_link_path = "vc_installation_error_arm.bat",
    msvc_lib_path = "vc_installation_error_arm.bat",
    cxx_builtin_include_directories = [],
    tool_paths = {
        "ar": "vc_installation_error_arm.bat",
        "ml": "vc_installation_error_arm.bat",
        "cpp": "vc_installation_error_arm.bat",
        "gcc": "vc_installation_error_arm.bat",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "vc_installation_error_arm.bat",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
        "dumpbin": "%{msvc_dumpbin_path_arm}",
        "cpp-module-deps-scanner": "msvc_deps_scanner_wrapper_arm.bat",
    },
    archiver_flags = ["/MACHINE:ARM"],
    default_link_flags = ["/MACHINE:ARM"],
    dbg_mode_debug_flag = "/DEBUG",
    fastbuild_mode_debug_flag = "/DEBUG",
    supports_parse_showincludes = False,
)

toolchain(
    name = "cc-toolchain-x64_arm_windows",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:arm",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_arm_windows",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-arm64_windows",
    toolchain_identifier = "msvc_arm64",
    toolchain_config = ":msvc_arm64",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":msvc_compiler_files",
    compiler_files = ":msvc_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "msvc_arm64",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "msvc_arm64",
    msvc_env_tmp = "msvc_not_found",
    msvc_env_path = "msvc_not_found",
    msvc_env_include = "msvc_not_found",
    msvc_env_lib = "msvc_not_found",
    msvc_cl_path = "vc_installation_error_arm64.bat",
    msvc_ml_path = "vc_installation_error_arm64.bat",
    msvc_link_path = "vc_installation_error_arm64.bat",
    msvc_lib_path = "vc_installation_error_arm64.bat",
    cxx_builtin_include_directories = [],
    tool_paths = {
        "ar": "vc_installation_error_arm64.bat",
        "ml": "vc_installation_error_arm64.bat",
        "cpp": "vc_installation_error_arm64.bat",
        "gcc": "vc_installation_error_arm64.bat",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "vc_installation_error_arm64.bat",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
        "dumpbin": "%{msvc_dumpbin_path_arm64}",
        "cpp-module-deps-scanner": "msvc_deps_scanner_wrapper_arm64.bat",
    },
    archiver_flags = ["/MACHINE:ARM64"],
    default_link_flags = ["/MACHINE:ARM64"],
    dbg_mode_debug_flag = "/DEBUG",
    fastbuild_mode_debug_flag = "/DEBUG",
    supports_parse_showincludes = False,
)

toolchain(
    name = "cc-toolchain-arm64_windows",
    exec_compatible_with = [
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:arm64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-arm64_windows",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)


cc_toolchain(
    name = "cc-compiler-x64_windows-clang-cl",
    toolchain_identifier = "clang_cl_x64",
    toolchain_config = ":clang_cl_x64",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":clangcl_compiler_files",
    compiler_files = ":clangcl_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "clang_cl_x64",
    cpu = "x64_windows",
    compiler = "clang-cl",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "clang_cl_x64",
    msvc_env_tmp = "clang_cl_not_found",
    msvc_env_path = "clang_cl_not_found",
    msvc_env_include = "clang_cl_not_found",
    msvc_env_lib = "clang_cl_not_found",
    msvc_cl_path = "clang_installation_error.bat",
    msvc_ml_path = "clang_installation_error.bat",
    msvc_link_path = "clang_installation_error.bat",
    msvc_lib_path = "clang_installation_error.bat",
    cxx_builtin_include_directories = [],
    tool_paths = {
        "ar": "clang_installation_error.bat",
        "ml": "clang_installation_error.bat",
        "cpp": "clang_installation_error.bat",
        "gcc": "clang_installation_error.bat",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "clang_installation_error.bat",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
    },
    archiver_flags = ["/MACHINE:X64"],
    default_link_flags = ["/MACHINE:X64"],
    dbg_mode_debug_flag = "/DEBUG",
    fastbuild_mode_debug_flag = "/DEBUG",
    supports_parse_showincludes = False,
)

toolchain(
    name = "cc-toolchain-x64_windows-clang-cl",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:clang-cl",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-x64_windows-clang-cl",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-arm64_windows-clang-cl",
    toolchain_identifier = "clang_cl_arm64",
    toolchain_config = ":clang_cl_arm64",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":clangcl_compiler_files",
    compiler_files = ":clangcl_compiler_files",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

cc_toolchain_config(
    name = "clang_cl_arm64",
    cpu = "arm64_windows",
    compiler = "clang-cl",
    host_system_name = "local",
    target_system_name = "aarch64-pc-windows-msvc",
    target_libc = "msvcrt",
    abi_version = "local",
    abi_libc_version = "local",
    toolchain_identifier = "clang_cl_arm64",
    msvc_env_tmp = "clang_cl_not_found",
    msvc_env_path = "clang_cl_not_found",
    msvc_env_include = "clang_cl_not_found",
    msvc_env_lib = "clang_cl_not_found",
    msvc_cl_path = "vc_installation_error_arm64.bat",
    msvc_ml_path = "vc_installation_error_arm64.bat",
    msvc_link_path = "vc_installation_error_arm64.bat",
    msvc_lib_path = "vc_installation_error_arm64.bat",
    cxx_builtin_include_directories = [],
    tool_paths = {
        "ar": "vc_installation_error_arm64.bat",
        "ml": "vc_installation_error_arm64.bat",
        "cpp": "vc_installation_error_arm64.bat",
        "gcc": "vc_installation_error_arm64.bat",
        "gcov": "wrapper/bin/msvc_nop.bat",
        "ld": "vc_installation_error_arm64.bat",
        "nm": "wrapper/bin/msvc_nop.bat",
        "objcopy": "wrapper/bin/msvc_nop.bat",
        "objdump": "wrapper/bin/msvc_nop.bat",
        "strip": "wrapper/bin/msvc_nop.bat",
    },
    archiver_flags = ["/MACHINE:ARM64"],
    default_link_flags = ["/MACHINE:ARM64"],
    dbg_mode_debug_flag = "/DEBUG",
    fastbuild_mode_debug_flag = "/DEBUG",
    supports_parse_showincludes = False,
)

toolchain(
    name = "cc-toolchain-arm64_windows-clang-cl",
    exec_compatible_with = [
        "@platforms//os:windows",
        "@rules_cc//cc/private/toolchain:clang-cl",
    ],
    target_compatible_with = [
        "@platforms//cpu:arm64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-compiler-arm64_windows-clang-cl",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "cc-compiler-armeabi-v7a",
    toolchain_identifier = "stub_armeabi-v7a",
    toolchain_config = ":stub_armeabi-v7a",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
)

armeabi_cc_toolchain_config(name = "stub_armeabi-v7a")

toolchain(
    name = "cc-toolchain-armeabi-v7a",
    exec_compatible_with = [
    ],
    target_compatible_with = [
        "@platforms//cpu:armv7",
        "@platforms//os:android",
    ],
    toolchain = ":cc-compiler-armeabi-v7a",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
