#include <iostream>
#include <windows.h>
#include <string>
#include <vector>
#include <filesystem>
#include <fstream>
#include <shlobj.h>

namespace fs = std::filesystem;

void SetColor(int color) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hConsole, color);
}

void PrintBanner() {
    SetColor(11);
    std::cout << R"(
    ╔══════════════════════════════════════════════════════════╗
    ║  ███████╗███████╗██████╗     ██████╗ ███████╗██╗  ██╗  ║
    ║  ██╔════╝██╔════╝╚════██╗   ██╔════╝ ██╔════╝██║  ██║  ║
    ║  █████╗  █████╗   █████╔╝   ██║  ███╗█████╗  ███████║  ║
    ║  ██╔══╝  ██╔══╝   ╚═══██╗   ██║   ██║██╔══╝  ██╔══██║  ║
    ║  ███████╗███████╗██████╔╝██╗╚██████╔╝███████╗██║  ██║  ║
    ║  ╚══════╝╚══════╝╚═════╝ ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝  ║
    ╚══════════════════════════════════════════════════════════╝
    )" << std::endl;
    SetColor(7);
    std::cout << "        RE9 Camera Tools + Visual Tweaks Installer v1.0\n";
    std::cout << "        ==============================================\n\n";
}

bool BrowseFolder(std::string& outPath) {
    BROWSEINFO bi = { 0 };
    bi.lpszTitle = L"Select Resident Evil Requiem installation folder (where RE9.exe is located)";
    bi.ulFlags = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE;

    LPITEMIDLIST pidl = SHBrowseForFolder(&bi);
    if (pidl != 0) {
        wchar_t path[MAX_PATH];
        if (SHGetPathFromIDList(pidl, path)) {
            std::wstring ws(path);
            outPath = std::string(ws.begin(), ws.end());
            return true;
        }
    }
    return false;
}

bool IsValidGameFolder(const std::string& folder) {
    fs::path exePath = fs::path(folder) / "RE9.exe";
    return fs::exists(exePath);
}

bool HasREFramework(const std::string& folder) {
    fs::path dllPath = fs::path(folder) / "dinput8.dll";
    return fs::exists(dllPath);
}

int main() {
    PrintBanner();

    // Get current directory
    wchar_t exePath[MAX_PATH];
    GetModuleFileNameW(NULL, exePath, MAX_PATH);
    fs::path currentDir = fs::path(exePath).parent_path();

    // Find scripts folder
    fs::path scriptsSrc = currentDir / "scripts";
    fs::path configsSrc = currentDir / "configs";

    if (!fs::exists(scriptsSrc)) {
        SetColor(12);
        std::cout << "[-] Error: scripts folder not found in installer directory!\n";
        SetColor(7);
        system("pause");
        return 1;
    }

    // Select game folder
    std::string gameFolder;
    std::cout << "\nSelect your RE9 installation folder (where RE9.exe is located).\n";
    std::cout << "If you already have REFramework, scripts will be added to it.\n\n";

    if (BrowseFolder(gameFolder)) {
        std::cout << "Selected folder: " << gameFolder << std::endl;
    } else {
        std::cout << "No folder selected. Exiting.\n";
        system("pause");
        return 0;
    }

    if (!IsValidGameFolder(gameFolder)) {
        SetColor(14);
        std::cout << "[!] Warning: RE9.exe not found in this folder. Installation may not work.\n";
        std::cout << "Continue anyway? (y/n): ";
        char c;
        std::cin >> c;
        if (c != 'y' && c != 'Y') {
            std::cout << "Installation cancelled.\n";
            system("pause");
            return 0;
        }
        SetColor(7);
    }

    // Check for REFramework
    bool hasReframework = HasREFramework(gameFolder);
    if (!hasReframework) {
        SetColor(14);
        std::cout << "\n[!] REFramework (dinput8.dll) not found in game folder.\n";
        std::cout << "    Some camera features require REFramework to work.\n";
        std::cout << "    Continue anyway? (y/n): ";
        char c;
        std::cin >> c;
        if (c != 'y' && c != 'Y') {
            std::cout << "Installation cancelled.\n";
            system("pause");
            return 0;
        }
        SetColor(7);
    }

    // Create autorun folder
    fs::path autorunPath = fs::path(gameFolder) / "reframework" / "autorun";
    if (!fs::exists(autorunPath)) {
        try {
            fs::create_directories(autorunPath);
            std::cout << "[+] Created " << autorunPath << std::endl;
        } catch (const std::exception& e) {
            SetColor(12);
            std::cout << "[-] Failed to create directories: " << e.what() << std::endl;
            SetColor(7);
            system("pause");
            return 1;
        }
    }

    // Copy Lua scripts
    std::cout << "\n[*] Copying Lua scripts to reframework/autorun...\n";
    int copied = 0;
    for (const auto& entry : fs::directory_iterator(scriptsSrc)) {
        if (entry.is_regular_file() && entry.path().extension() == ".lua") {
            fs::path dest = autorunPath / entry.path().filename();
            try {
                fs::copy_file(entry.path(), dest, fs::copy_options::overwrite_existing);
                std::cout << "  [+] " << entry.path().filename() << std::endl;
                copied++;
            } catch (const std::exception& e) {
                SetColor(12);
                std::cout << "  [-] Failed to copy " << entry.path().filename() << ": " << e.what() << std::endl;
                SetColor(7);
            }
        }
    }
    std::cout << "[+] Copied " << copied << " scripts.\n";

    // Copy config files if present
    if (fs::exists(configsSrc)) {
        std::cout << "\n[*] Copying configuration files...\n";
        for (const auto& entry : fs::directory_iterator(configsSrc)) {
            fs::path dest = fs::path(gameFolder) / entry.path().filename();
            try {
                fs::copy_file(entry.path(), dest, fs::copy_options::overwrite_existing);
                std::cout << "  [+] " << entry.path().filename() << std::endl;
            } catch (const std::exception& e) {
                std::cout << "  [-] Failed to copy " << entry.path().filename() << std::endl;
            }
        }
    }

    // Create backup of original configs
    std::cout << "\n[*] Creating backup of original game files...\n";
    fs::path backupFolder = fs::path(gameFolder) / "RE9_Visual_Backup";
    try {
        fs::create_directories(backupFolder);
        
        // Backup important files if they exist
        std::vector<std::string> filesToBackup = {
            "dinput8.dll",
            "renodx-re9requiem.addon64",
            "UltrawideFix.ini"
        };
        
        for (const auto& file : filesToBackup) {
            fs::path src = fs::path(gameFolder) / file;
            if (fs::exists(src)) {
                fs::copy_file(src, backupFolder / file, fs::copy_options::overwrite_existing);
                std::cout << "  [+] Backed up " << file << std::endl;
            }
        }
    } catch (const std::exception& e) {
        std::cout << "  [!] Backup failed: " << e.what() << std::endl;
    }

    std::cout << "\n========================================\n";
    SetColor(10);
    std::cout << "✓ Installation complete!\n";
    SetColor(7);
    std::cout << "========================================\n\n";
    
    std::cout << "Next steps:\n";
    std::cout << "1. Launch Resident Evil Requiem\n";
    std::cout << "2. Press INSERT to open REFramework menu\n";
    std::cout << "3. Navigate to Script Generated UI → Camera Tools\n";
    std::cout << "4. Adjust settings to your liking\n";
    std::cout << "5. Hotkeys: F5 (1st/3rd person), F6/F7 (FOV), F9 (freecam)\n\n";
    
    std::cout << "If you installed the HDR fix:\n";
    std::cout << "- Press HOME to open ReShade menu\n";
    std::cout << "- Go to RenoDX tab and configure for your display\n\n";
    
    system("pause");
    return 0;
}