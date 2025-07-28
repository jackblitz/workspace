@echo off
echo =================================================================
echo  Starting iBazel Watcher for Hot Reloading
echo =================================================================
echo.
echo  This will automatically rebuild the project when you save a file.
echo  Keep this terminal open.
echo.
echo  In another terminal or in VS Code, run the 'Debug Host (MSVC)'
echo  configuration to see the changes hot-reloaded.
echo.
echo =================================================================
echo.

ibazel build --config=debug-hot-reload //modules/game_logic //host:copy_game_logic_dll
