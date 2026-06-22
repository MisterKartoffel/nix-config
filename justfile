tmpdir := justfile_directory()

default:
	@just --list

os ACTION="test": rebuild-pre
	@nh os {{ACTION}} . --ask

look:
	@tack look --verbose

update:
	@TMPDIR={{tmpdir}} tack update

[private]
rebuild-pre: update-secrets
	@git add --intent-to-add .

[private]
update-secrets:
	@tack update nix-secrets
