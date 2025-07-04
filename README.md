# Project Setup

This project uses CMake for building. To configure the project, use the provided scripts.

## CLion Users

If you are using CLion, you can open the `workspace` directory as the project root. CLion will automatically detect the `CMakeLists.txt` file and configure the project for you.

## Command Line Users

For command-line users, scripts are provided to configure the project for different build types.

### Windows

Use the `install.bat` script with one of the following options:

```batch
install.bat -debug
install.bat -release
```

### macOS and Linux

Use the `install.sh` script. You may need to make it executable first:

```bash
chmod +x install.sh
```

Then, run it with one of the following options:

```bash
./install.sh -debug
./install.sh -release
```

## Building the Project

After configuring the project, you can build it using the following scripts:

### Windows

```batch
build.bat -debug
build.bat -release
```

### macOS and Linux

```bash
./build.sh -debug
./build.sh -release
```
