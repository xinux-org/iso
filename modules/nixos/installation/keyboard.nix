{...}: {
  # Configure keymap
  services.xserver = {
    xkb = {
      # layout from: https://github.com/itsbilolbek/uzbek-linux-keyboard
      extraLayouts.uz = {
        description = "Uzbek (Oʻzbekiston)";
        languages = ["eng" "uzb"];
        symbolsFile = ../../../.github/assets/uz_keyboard;
      };
      layout = "uz,us,ru";
      variant = "latin";
    };
  };
}
