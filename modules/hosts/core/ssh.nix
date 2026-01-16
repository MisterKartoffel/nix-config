{
	services.openssh = {
		enable = true;

		settings = {
			PermitRootLogin = "no";
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
		};
	};

	programs.ssh.startAgent = true;
}
