{
  xdg.config.files."neomutt/keybinds".text = /* muttrc */ ''
    macro index - "<change-folder>?" "Change to folder overview"

    bind attach,browser,index,pager g noop
    bind attach,browser,index gg first-entry
    bind attach,browser,index G last-entry

    bind attach,browser,index,pager \Cu half-up
    bind attach,browser,index,pager \Cd half-down

    bind index k previous-entry
    bind index j next-entry

    bind pager gg top
    bind pager G bottom
    bind pager k previous-line
    bind pager j next-line
  '';
}
