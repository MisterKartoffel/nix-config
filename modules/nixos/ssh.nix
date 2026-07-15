{
  programs.ssh.extraConfig = ''
    Host *
    	AddKeysToAgent yes
    	IdentitiesOnly yes
    	IdentityFile /home/mimikyu/.ssh/id_ed25519

    Host kindle
    	HostName 192.168.0.202
    	SetEnv TERM=linux
  '';
}
