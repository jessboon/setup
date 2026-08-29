macOS Developer Setup

A lightweight, reproducible macOS development environment.

This repository bootstraps a new Mac with the tools, terminal configuration, editor configuration, Git/SSH/GPG setup, and CLI aliases I use for day-to-day development.

What's Included
Homebrew
 — package management
Ghostty
 — terminal
NvChad
 + Neovim — editor
Visual Studio Code
 — GUI editor
OpenCode
 — terminal AI coding agent
Docker Desktop — containers
kubectl — Kubernetes CLI
fnm — Node.js version manager
pnpm — Node package manager
uv — Python package/project manager
eza — modern ls
bat — modern cat
Git
GPG + pinentry-mac — commit signing
SSH — GitHub authentication
Repository Structure
.
├── jboonekamp-setup.sh
│
├── zsh/
│   └── .zshrc
│
├── ghostty/
│   └── config
│
├── nvim/
│   └── lua/
│       ├── chadrc.lua
│       └── plugins/
│           └── theme.lua
│
└── opencode/
    └── opencode.json


Configuration files are kept in the repository and installed into their expected locations by jboonekamp-setup.sh.

Where appropriate, the setup uses symlinks so changes to the repository configuration are immediately reflected in the active configuration.

Installation
1. Clone the repository
git clone git@github.com:<username>/<repo>.git
cd <repo>

2. Run the setup
chmod +x jboonekamp-setup.sh
./jboonekamp-setup.sh


The script installs the required Homebrew packages and applications, configures the shell, Ghostty, NvChad, and OpenCode, and sets up the development environment.

3. Reload Zsh
source ~/.zshrc


Or simply open a new Ghostty window.

Shell

The shell configuration lives at:

zsh/.zshrc


The setup installs it as the active Zsh configuration.

Node.js

Node is managed with fnm.

fnm install --lts
fnm use --lts


Because fnm is configured with:

eval "$(fnm env --use-on-cd)"


Node versions can automatically switch when entering directories containing the appropriate version configuration.

pnpm

pnpm is installed through Homebrew.

The shell config includes:

export PNPM_HOME="$HOME/Library/pnpm"

CLI Aliases

The shell is intentionally configured around short, memorable commands.

Files
ls
ll
la
lt
lst
lst 3


Examples:

lst


Shows two levels of the current directory.

lst 3


Shows three levels.

eza replaces the standard ls:

ls → eza


bat replaces cat:

cat → bat

Git
g      → git
gs     → git status
ga     → git add
gaa    → git add --all
gc     → git commit
gca    → git commit --amend
gp     → git push
gpl    → git pull
gd     → git diff
gds    → git diff --staged
gl     → git log --oneline --decorate --graph
gco    → git checkout
gsw    → git switch
gb     → git branch
gba    → git branch -a

Docker
d      → docker
dc     → docker compose

dps    → docker ps
dpa    → docker ps -a
di     → docker images

dcu    → docker compose up
dcud   → docker compose up -d
dcd    → docker compose down
dcl    → docker compose logs -f

Kubernetes
k      → kubectl

kg     → kubectl get
kgp    → kubectl get pods
kgs    → kubectl get services
kgn    → kubectl get nodes
kga    → kubectl get all
kgi    → kubectl get ingress

kd     → kubectl describe
kdp    → kubectl describe pod

kl     → kubectl logs
klf    → kubectl logs -f

ke     → kubectl exec -it

ka     → kubectl apply -f
kdelf  → kubectl delete -f

kctx   → current context
kcontexts
kuse   → switch context


Useful functions:

kroll deployment-name


Restarts a deployment.

kwatch


Watches pods.

Neovim
v      → nvim
vi     → nvim
vim    → nvim

OpenCode
oc → opencode


Run:

oc


to start OpenCode.

Ghostty

Ghostty is configured as a minimal dark terminal.

Configuration:

ghostty/config


The current setup uses:

JetBrains Mono
Small font size
Catppuccin Mocha
Transparent background
Background blur
Minimal window padding
Block cursor
Zsh shell integration
No scrollbar
Mouse hiding while typing

The terminal is intentionally slightly transparent:

background-opacity = 0.82


This can be adjusted in ghostty/config.

Neovim / NvChad

NvChad is used as the Neovim configuration framework.

Configuration:

nvim/
├── lua/
│   ├── chadrc.lua
│   └── plugins/
│       └── theme.lua


The editor uses a minimal dark Catppuccin Mocha theme with:

Transparent background
Minimal statusline
Muted line numbers
Subtle cursor line
Minimal UI
Dark floating windows
Restrained syntax highlighting

Start Neovim with:

v

OpenCode

OpenCode configuration lives at:

opencode/opencode.json


The current configuration keeps the setup deliberately minimal while enabling the Catppuccin theme and automatic updates.

Start OpenCode with:

oc

Python

Python tooling is handled by uv.

Examples:

uv python install 3.13


Create a project:

uv init my-project
cd my-project


Create a virtual environment:

uv venv


Install dependencies:

uv add requests


Run commands:

uv run python main.py

Docker

Docker Desktop is installed as part of the setup.

Start Docker Desktop:

open -a Docker


Verify:

docker info


Test:

docker run hello-world


Docker Compose is available through:

dc

Kubernetes

kubectl is installed through Homebrew.

Check:

kubectl version --client


or:

k version --client


Useful commands:

k get pods
k get nodes
k get services
k get ingress


Check the current context:

kctx


List contexts:

kcontexts


Switch context:

kuse <context>

Git + GitHub

Git is configured to use SSH for GitHub authentication.

The recommended SSH key type is:

Ed25519


Generate a GitHub key:

ssh-keygen -t ed25519 -C "your-email@example.com"


Recommended key location:

~/.ssh/id_ed25519_github


SSH configuration:

~/.ssh/config


Example:

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  AddKeysToAgent yes
  UseKeychain yes


Test:

ssh -T git@github.com

Git Commit Signing

GPG is used to sign Git commits.

Install:

brew install gnupg pinentry-mac


Generate a key:

gpg --full-generate-key


List keys:

gpg --list-secret-keys --keyid-format=long


Configure Git:

git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true
git config --global gpg.program "$(which gpg)"


Export the public key for GitHub:

gpg --armor --export <KEY_ID> | pbcopy


Add it to:

GitHub → Settings → SSH and GPG keys → New GPG key

The email associated with the GPG key should be verified on GitHub for commits to appear as Verified.

Recommended Git Configuration

A fresh Mac can be configured with:

git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global commit.gpgsign true


Check the configuration:

git config --global --list

Quality of Life

Create and enter a directory:

mkcd project


Reload Zsh:

reload


Clear the terminal:

c


Move up directories:

..
...
....


Extract archives:

extract archive.tar.gz

Philosophy

This setup intentionally avoids trying to configure every possible developer tool.

The priorities are:

Fast startup
Minimal configuration
Good defaults
Keyboard-driven workflow
Dark, low-distraction UI
Reproducibility
Configuration stored in Git
Easy recovery on a new Mac

The setup should be easy to understand and modify rather than becoming a framework of its own.

Updating the Setup

After changing configuration files:

git add .
git commit -m "Update macOS setup"
git push


On another Mac:

git pull
./jboonekamp-setup.sh

Personal configuration. Use whatever is useful.