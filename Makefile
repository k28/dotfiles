#DOT_FILES = .bash_profile .bashrc .gvimrc .vim .vimrc
DOT_FILES = .bashrc .gvimrc .vim .vimrc

all: bash vim gvim

vimonly: vim gvim

bash: $(foreach f, $(filter .bash%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f))

gvim: $(foreach f, $(filter .gvim%, $(DOT_FILES)), link-dot-file-$(f))

.PHONY: clean
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))

link-dot-file-%: %
	@echo "Create Symlink $< => $(HOME)/$<"
	@ln -snf $(CURDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) -fr $(HOME)/$<

