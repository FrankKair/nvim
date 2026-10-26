.PHONY: update

update:
	nvim --headless "+Lazy! sync" +qa
