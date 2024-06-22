{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      stirling-pdf
    ];
  };
}
