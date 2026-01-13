{
	services.openssh = {
		enable = true;

		settings = {
			PermitRootLogin = "no";
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
		};
	};

	users.users.mimikyu.openssh.authorizedKeys.keys = [
		(builtins.readFile ../../home/mimikyu/ssh-keys/id_termius.pub)
	];
}
