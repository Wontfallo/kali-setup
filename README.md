# Kali Linux Ultimate Setup Script

A comprehensive script to transform a fresh Kali Linux installation into a fully customized penetration testing environment with enhanced productivity features, visual improvements, and security-focused tools.

![Kali Linux Setup](https://i.imgur.com/XYZ123.png)

## 🚀 Features

### 🛠️ Shell Enhancements
- **Zsh with Oh My Zsh** - A more powerful shell with plugin support
- **Powerlevel10k theme** - Beautiful, informative prompt with git integration
- **Syntax highlighting** - Color-coded command syntax
- **Auto-suggestions** - Fish-like command suggestions based on history

### 🎨 Visual Improvements
- **Custom terminal colors** - Eye-friendly color scheme
- **Nerd Fonts** - Patched fonts with icons and glyphs
- **Directory colors** - Enhanced file type coloring
- **Welcome dashboard** - System info and security tips on startup

### 🔐 Security Tools & Functions
- **Penetration testing directory structure** - Organized project templates
- **Network scanning shortcuts** - Quick commands for reconnaissance
- **Reverse shell generator** - Generate payloads for various languages
- **Security-focused aliases** - Shortcuts for common security tools

### ⚙️ Productivity Boosters
- **Custom aliases** - Shortcuts for common commands
- **Advanced extraction function** - Handle any archive format
- **Tmux configuration** - Terminal multiplexer with mouse support
- **Vim enhancements** - Improved text editor configuration

## 📋 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/wontfallo/kali-setup.git
   cd kali-setup
   ```

2. Make the script executable:
   ```bash
   chmod +x setup.sh
   ```

3. Run the script:
   ```bash
   ./setup.sh
   ```

4. Follow the Powerlevel10k configuration wizard that appears after restart

## 🔧 What's Included

### 🐚 Shell Configuration
- **Zsh** with Oh My Zsh framework
- **Powerlevel10k** theme with custom configuration
- **Plugins**: 
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - git
  - sudo
  - web-search
  - copypath
  - dirhistory
  - history
  - extract

### 🧰 Tools
- **System utilities**: htop, bat, fzf, ripgrep, eza, tmux
- **Security tools**: nmap, dirb, hydra, john, hashcat, wireshark, burpsuite, metasploit-framework, gobuster, nikto, wpscan, sqlmap

### 🔍 Custom Functions
- `newpentest <name>` - Creates a new penetration testing project structure
- `scan_network <cidr>` - Scans a network for live hosts
- `quickscan <target>` - Performs a quick vulnerability scan
- `webserver [port]` - Starts a Python HTTP server
- `revshell <ip> <port> <type>` - Generates reverse shell payloads
- `extract <file>` - Extracts various archive formats
- `mkcd <dir>` - Creates and changes to a directory

### ⚡ Aliases
- Network tools: `myip`, `localip`, `ports`, `listening`
- Security tools: `msf`, `burp`, `sqlmap`, `nmap_*`
- System shortcuts: `update`, `install`, `remove`
- File operations: `ll`, `la`, `cat` (using bat)

### 📝 Configuration Files
- `.zshrc` - Zsh configuration
- `.p10k.zsh` - Powerlevel10k theme settings
- `.vimrc` - Vim editor configuration
- `.tmux.conf` - Tmux terminal multiplexer settings
- `.dircolors` - Custom directory colors
- `terminator/config` - Terminal emulator settings

## 🔄 Updating

To update all tools and configurations:

```bash
update-tools
```

This will update:
- System packages
- Metasploit Framework
- SearchSploit database
- Nmap scripts
- Python packages
- Oh My Zsh and plugins

## 🎨 Customization

You can customize any aspect of this setup by editing the configuration files:

- Shell: `~/.zshrc`
- Theme: `~/.p10k.zsh`
- Vim: `~/.vimrc`
- Tmux: `~/.tmux.conf`
- Terminal: `~/.config/terminator/config`

## 📸 Screenshots

![Terminal Screenshot](https://i.imgur.com/ABC123.png)
![Tools in Action](https://i.imgur.com/DEF456.png)

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/kali-setup/issues).

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Kali Linux](https://www.kali.org/)
