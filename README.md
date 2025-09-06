# Run Commands

My personalized [rc](http://www.catb.org/~esr/writings/taoup/html/ch10s03.html) files.

# Installation

```
# Install Oh My Tmux!
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# Install HomeBrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install coreutils

# Install clipboard history tool
brew cask install clipy

# Install latest Vim
brew install vim

brew install ripgrep

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install asdf version manager
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"

mkdir -p $HOME/github
git clone https://github.com/vasuadari/.zshrc.git $HOME/github
cp -r $HOME/github/.profile.d $HOME/
ln -n $HOME/github/.zshrc $HOME/.zshrc
```

or run

```
$HOME/github/install.sh
```
