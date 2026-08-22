# Run Controls

My declarative macOS system configuration using [Nix-Darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager).

## Overview

This repository contains my complete macOS system configuration:

- **Nix-Darwin** for system-level configuration
- **Home Manager** for user environment (packages, dotfiles)
- **Nix packages** for reproducible CLI tools
- **Homebrew** (via nix-homebrew) for GUI apps and proprietary tools
- **Dotfiles** for tmux, neovim, alacritty, hammerspoon, etc.

## Structure

```
.run_controls/
├── .config/
│   ├── darwin/
│   │   ├── flake.nix           # Main Nix flake (system config)
│   │   ├── configuration.nix   # System-level settings
│   │   └── home.nix            # User packages & dotfiles
│   ├── just/justfile           # Task runner commands
│   ├── nvim/                   # Neovim configuration
│   ├── tmux/                   # Tmux configuration
│   ├── alacritty/              # Terminal emulator config
│   └── dnsmasq.conf            # Local DNS configuration
├── .hammerspoon/               # Hammerspoon (window management)
└── .profile.d/                 # Shell profile scripts
```

## Prerequisites

1. **macOS** (Apple Silicon or Intel)
2. **Nix package manager** with flakes enabled
3. **Git** for version control

## Installation

### 1. Install Nix

```bash
# Install Nix with daemon support
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Or use the official installer:
# sh <(curl -L https://nixos.org/nix/install)
```

### 2. Clone this repository

```bash
git clone <your-repo-url> ~/.run_controls
cd ~/.run_controls
```

### 3. Initial system build

```bash
# Navigate to the darwin config
cd ~/.run_controls/.config/darwin

# Build and activate the system configuration
nix run nix-darwin -- switch --flake .#work
```

### 4. Install global tools

The configuration will:
- Install Nix packages to your user profile
- Set up Homebrew and install casks (GUI apps)
- Symlink dotfiles to your home directory
- Configure system settings (DNS, LaunchD services, etc.)

### 5. Set up shell

Add to your `~/.zshrc` (if not already configured):

```bash
# Source profile scripts
for script in ~/.profile.d/*; do
  [ -r "$script" ] && source "$script"
done

# Ensure nix binaries are in PATH
export PATH="/etc/profiles/per-user/$USER/bin:$HOME/.nix-profile/bin:$PATH"
```

## Usage

### Rebuilding the system

After making changes to the configuration:

```bash
# Using the justfile (recommended)
just -g switch

# Or manually
cd ~/.run_controls/.config/darwin
nix run nix-darwin -- build --flake .#work
sudo ./result/activate
sudo nix-env -p /nix/var/nix/profiles/system --set ./result
```

### Managing packages

#### Add a Nix package

Edit `~/.run_controls/.config/darwin/home.nix`:

```nix
packages = with pkgs; [
  # ... existing packages
  neofetch  # Add your package here
];
```

Then rebuild: `just -g switch`

#### Add a Homebrew formula (CLI tool)

Only for packages not available in Nixpkgs. Edit `flake.nix`:

```nix
homebrew.brews = [
  "your-proprietary-tool"
];
```

#### Add a Homebrew cask (GUI app)

Edit `flake.nix`:

```nix
homebrew.casks = [
  "your-gui-app"
];
```

### Editing configuration files

```bash
# Edit main flake
just -g nflake

# Edit home-manager config
just -g nhome

# Edit justfile tasks
$EDITOR ~/.run_controls/.config/just/justfile
```

### Rollback to previous generation

If something breaks:

```bash
# List all generations
darwin-rebuild --list-generations

# Rollback to previous
darwin-rebuild --rollback

# Or switch to specific generation
darwin-rebuild switch --switch-generation <number>
```

## Key Features

### Declarative Configuration

Everything is defined in code:
- System packages and settings
- User environment and dotfiles
- GUI applications
- LaunchD services

### Reproducibility

The entire system can be recreated from this repository on any Mac by running:

```bash
nix run nix-darwin -- switch --flake github:vasuadari/.run_controls?.config/darwin#work
```

### Atomic Updates & Rollbacks

- Each rebuild creates a new generation
- Switch between generations instantly
- Rollback if something breaks

### Nix Binary Cache

Most packages install instantly from binary caches instead of building from source.

## Dotfiles Management

Dotfiles are **symlinked** (not copied) using Home Manager:

```nix
home.file = {
  ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink 
    "/Users/vadari/.run_controls/.config/nvim";
};
```

This means:
- ✅ Edit dotfiles in place in `.run_controls`
- ✅ Changes take effect immediately (no rebuild needed)
- ✅ Easy to commit and track changes in git

## Services

### LaunchD Services

Configured services that start automatically:

- **llama-server**: Local LLM inference server (port 8080)
- **dnsmasq**: Local DNS resolver for development

Manage services:

```bash
# Check service status
launchctl list | grep llama-server

# Stop a service
launchctl stop org.nixos.llama-server

# View logs
tail -f /tmp/llama-server_vasuadari.out.log
```

## Customization

### For a new machine

1. Update the hostname in `flake.nix` (or use the `#work` configuration name)
2. Update username in `configuration.nix` if different
3. Review and modify package lists in `home.nix`
4. Commit and rebuild

### Adding custom tools

For tools not in Nixpkgs or Homebrew:

```nix
# In home.nix, create custom derivations or use buildInputs
home.packages = [
  (pkgs.writeShellScriptBin "my-tool" ''
    echo "Custom script"
  '')
];
```

## Troubleshooting

### Git tree has uncommitted changes

Nix flakes require a clean git tree. Commit or stash changes before rebuilding:

```bash
git add -A
git commit -m "Update configuration"
just -g switch
```

### Build fails with "cannot build derivation"

Check the error message and:
1. Ensure all packages exist in Nixpkgs: `nix search nixpkgs <package>`
2. Check for package name conflicts
3. Read full logs: `nix log <derivation-path>`

### Homebrew casks not installing

```bash
# Trust taps manually if needed
brew trust atlassian/acli
brew trust metalbear-co/mirrord

# Reinstall casks
brew reinstall --cask <cask-name>
```

### System not activating

```bash
# Check for errors in activation script
sudo /nix/var/nix/profiles/system/activate

# View system logs
log show --predicate 'process == "nix-daemon"' --last 10m
```

## Package Counts

- **Nix packages**: ~70 CLI tools
- **Homebrew brews**: ~6 proprietary tools
- **Homebrew casks**: ~20 GUI applications

## Philosophy

This configuration follows **The Nix Way**:

1. **Declarative**: Everything in code, no manual `brew install`
2. **Reproducible**: Same config = same system
3. **Atomic**: Updates are all-or-nothing
4. **Rollback**: Previous states always available
5. **Minimal Homebrew**: Only for what Nix can't provide

## References

- [Nix-Darwin Manual](https://daiderd.com/nix-darwin/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [Zero to Nix](https://zero-to-nix.com/)

## License

Personal configuration - use at your own risk!

---

**Last Updated**: 2026-08-22
