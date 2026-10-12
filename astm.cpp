#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <nlohmann/json.hpp>

namespace fs = std::filesystem;
using json = nlohmann::json;

const fs::path baseDir = fs::path(getenv("HOME")) / ".local/share/astm";
const fs::path assetsDir = baseDir / "assets";
const fs::path configFile = baseDir / "config.json";

void ensureDirs() { fs::create_directories(assetsDir); }

void saveConfig(const std::string &destPath) {
  json j;
  j["destination"] = destPath;
  std::ofstream(configFile) << j.dump(4);
}

std::string getDestination() {
  if (!fs::exists(configFile))
    return "";
  std::ifstream f(configFile);
  json j;
  f >> j;
  return j["destination"];
}

void cmdInit(const std::string &path) {
  ensureDirs();
  saveConfig(path);
  std::cout << "Set destination to: " << path << "\n";
}

void cmdAdd(const std::string &name, const std::string &src) {
  ensureDirs();
  fs::path dst = assetsDir / name;
  fs::create_directories(dst);
  fs::copy(src, dst,
           fs::copy_options::recursive | fs::copy_options::overwrite_existing);
  std::cout << "Added asset: " << name << "\n";
}

void cmdFetch(const std::string &name) {
  std::string dest = getDestination();
  if (dest.empty()) {
    std::cerr << "Run 'astm init <path>' first!\n";
    return;
  }
  fs::path src = assetsDir / name;
  if (!fs::exists(src)) {
    std::cerr << "Asset not found: " << name << "\n";
    return;
  }
  fs::copy(src, dest,
           fs::copy_options::recursive | fs::copy_options::overwrite_existing);
  std::cout << "Fetched asset: " << name << " → " << dest << "\n";
}

void cmdList() {
  for (auto &p : fs::directory_iterator(assetsDir))
    if (fs::is_directory(p))
      std::cout << p.path().filename().string() << "\n";
}

void cmdRemove(const std::string &name) {
  fs::path target = assetsDir / name;
  if (!fs::exists(target)) {
    std::cerr << "Asset not found: " << name << "\n";
    return;
  }

  fs::remove_all(target);
  std::cout << "Removed asset: " << name << "\n";
}

int main(int argc, char **argv) {
  if (argc < 2) {
    std::cout << "Usage: astm <command> [args]\n"
              << "Commands:\n"
              << "  init <path>       - Set destination path\n"
              << "  add <name> <path> - Add new asset\n"
              << "  fetch <name>      - Copy asset to destination\n"
              << "  remove <name>     - Delete an asset\n"
              << "  list              - Show all assets\n";
    return 0;
  }

  std::string cmd = argv[1];
  ensureDirs();

  if (cmd == "init" && argc >= 3)
    cmdInit(argv[2]);
  else if (cmd == "add" && argc >= 4)
    cmdAdd(argv[2], argv[3]);
  else if (cmd == "fetch" && argc >= 3)
    cmdFetch(argv[2]);
  else if (cmd == "remove" && argc >= 3)
    cmdRemove(argv[2]);
  else if (cmd == "list")
    cmdList();
  else
    std::cout << "Unknown or incomplete command.\n";
}
