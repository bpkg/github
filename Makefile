
BIN ?= github
PREFIX ?= /usr/local
CMDS = json authorization common events init json request token

install: uninstall
	install $(BIN) $(PREFIX)/bin
	for cmd in $(CMDS); do cp github-$${cmd} $(PREFIX)/bin/$(BIN)-$${cmd}; done

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	for cmd in $(CMDS); do rm -f $(PREFIX)/bin/$(BIN)-$${cmd}; done

link: uninstall
	ln -s $(BIN) $(PREFIX)/bin/$(BIN)
	for cmd in $(CMDS); do ln -s github-$${cmd} $(PREFIX)/bin/$(BIN)-$${cmd}; done

unlink: uninstall
