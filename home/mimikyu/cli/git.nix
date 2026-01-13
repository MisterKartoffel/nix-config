{ config, ... }:
let
	sshKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
in {
	programs.git = {
		enable = true;

		settings = {
			user = {
				name = "Felipe Duarte";
				email = "felipesdrs@hotmail.com";
				signingKey = "${sshKey}.pub";
			};

			core = {
				sshCommand = "ssh -i ${sshKey}";
				compression = 9;
				editor = "nvim";
				whitespace = "error";
			};

			alias."patch" = "add --patch";
			column.ui = "auto";
			commit.gpgsign = true;
			fetch.prune = true;
			gpg.format = "ssh";
			help.autocorrect = "prompt";
			init.defaultBranch = "main";
			interactive.singleKey = true;
			merge.conflictstyle = "zdiff3";
			pager.branch = false;
			push.autoSetupRemote = true;

			diff = {
				tool = "nvimdiff";
				algorithm = "histogram";
				renames = "copies";
			};

			rebase = {
				autoSquash = true;
				autoStash = true;
				updateRefs = true;
			};

			rerere = {
				enabled = true;
				autoupdate = true;
			};

			pull = {
				ff = "only";
				rebase = true;
			};

			status = {
				branch = true;
				showStash = true;
			};

			log = {
				abbrevCommit = true;
				graphColors = "blue,yellow,cyan,magenta,green,red";
			};

			color = {
				"branch" = {
					current = "magenta";
					local = "default";
					remote = "yellow";
					upstream = "green";
					plain = "blue";
				};

				"decorate" = {
					HEAD = "red";
					branch = "blue";
					remoteBranch = "magenta";
				};

				"diff" = {
					meta = "black bold";
					frag = "magenta";
					context = "white";
					whitespace = "yellow reverse";
					old = "red";
				};
			};
		};
	};
}
