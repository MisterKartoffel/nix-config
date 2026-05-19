{
  home.persistence."/etc/persist" = {
    hideMounts = true;

    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Mail"
      "Music"
      "Pictures"
      "Projects"
      "Public"
      "Templates"
      "Videos"
      ".config/zen"
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

    files = [
      ".ssh/known_hosts"
      ".config/zsh/.p10k.zsh"
      ".local/state/zsh/history"
    ];
  };
}
