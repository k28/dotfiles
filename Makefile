#DOT_FILES = .bash_profile .bashrc .gvimrc .vim .vimrc
DOT_FILES = .bash_profile .bashrc .gvimrc .vim .vimrc .ackrc .vrapperrc .xvimrc .inputrc .ideavimrc .tmux.conf .vimrc.plugins .emacs.d .zshrc

all: bash vim gvim ack vrapperrc xvimrc inputrc ideavimrc tmux zsh

vimonly: vim gvim vrapperrc xvimrc ideavimrc

emacsonly: emacs

ackonly: ack

zsh: $(foreach f, $(filter .zsh%, $(DOT_FILES)), link-dot-file-$(f))

bash: $(foreach f, $(filter .bash%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))

emacs: $(foreach f, $(filter .emacs%, $(DOT_FILES)), link-dot-file-$(f))

gvim: $(foreach f, $(filter .gvim%, $(DOT_FILES)), link-dot-file-$(f))

vrapperrc: $(foreach f, $(filter .vrapperrc, $(DOT_FILES)), link-dot-file-$(f))

xvimrc: $(foreach f, $(filter .xvimrc, $(DOT_FILES)), link-dot-file-$(f))

ideavimrc: $(foreach f, $(filter .ideavimrc, $(DOT_FILES)), link-dot-file-$(f))

ack: $(foreach f, $(filter .ack%, $(DOT_FILES)), link-dot-file-$(f))

inputrc: $(foreach f, $(filter .inputrc, $(DOT_FILES)), link-dot-file-$(f))

tmux: $(foreach f, $(filter .tmux.conf, $(DOT_FILES)), link-dot-file-$(f))

.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) -fr $(HOME)/$<

