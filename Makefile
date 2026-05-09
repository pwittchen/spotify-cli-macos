install:
	sudo cp spotifycli.sh /usr/local/bin/spotifycli
uninstall:
	sudo rm /usr/local/bin/spotifycli || true
install-mcp:
	sudo cp mcp/spotifycli-mcp.sh /usr/local/bin/spotifycli-mcp
uninstall-mcp:
	sudo rm /usr/local/bin/spotifycli-mcp || true