_: {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp3s0";
    enableIPv6 = true;
  };
}
