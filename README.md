
````markdown
# 🌐 ASTM — Lightweight Asset Manager

**ASTM** (Asset Manager) is a simple command-line tool to manage and version-control project assets locally.  
It keeps your files organized under `~/.local/share/astm/assets`, supports Git auto-sync, and allows you to fetch assets into any destination folder.

---

## 🚀 Features

- 📦 Manage assets (add, list, remove, fetch)
- 💾 Configurable destination directory
- 🔄 Git auto-commit and push for version control
- 🧱 Simple JSON-based config stored in `~/.local/share/astm/config.json`
- 🧰 Built-in Nix Flake and Makefile support

---

## ⚙️ Installation

### 🧑‍💻 Using Make

```bash
git clone https://github.com/<yourname>/astm.git
cd astm
make
sudo make install
````

This will compile `astm.cpp` and install the `astm` binary system-wide (usually into `/usr/local/bin`).

---

### ❄️ Using Nix (Recommended)

If you’re on **NixOS** or using **nix flakes**, you can build or enter the development shell easily.

#### Development Shell

```bash
nix develop
```

This gives you a shell with `gcc` and `nlohmann_json` ready.

#### Build the Package

```bash
nix build
```

#### Install System-Wide

```bash
nix profile install .#astm
```

---

## 🧭 Usage

```bash
astm <command> [args]
```

### Commands

| Command            | Description                              |
| ------------------ | ---------------------------------------- |
| `init <path>`      | Set destination path for asset fetches   |
| `add <name> <src>` | Add a new asset from a given source path |
| `fetch <name>`     | Copy asset to the configured destination |
| `remove <name>`    | Delete an existing asset                 |
| `list`             | Show all stored assets                   |

---

## 🪄 Examples

### 1. Initialize the asset destination

```bash
astm init ~/Projects/MyApp/assets
```

### 2. Add a new asset

```bash
astm add logo ./assets/logo/
```

### 3. Fetch an asset into destination

```bash
astm fetch logo
```

### 4. List all assets

```bash
astm list
```

### 5. Remove an asset

```bash
astm remove logo
```

---

## 🔁 Git Integration

If your `~/.local/share/astm` directory is a Git repository, `astm` will automatically:

* Commit every asset addition/removal
* Push changes to the remote

This allows you to **synchronize your asset library** across multiple systems.

---

## 🧩 Directory Structure

```
~/.local/share/astm/
├── assets/
│   ├── asset1/
│   └── asset2/
└── config.json
```

---

## 🛠️ Dependencies

* **C++17**
* **nlohmann/json** (header-only JSON library)

Both are automatically provided via Nix or installed manually if you compile via Make.

---

## 🧑‍💻 Author

**Ritish**
Full Stack Developer [Website](https://ritish.site)
---

## 🪪 License

MIT License © 2025 Ritish
Feel free to use, modify, and distribute.


