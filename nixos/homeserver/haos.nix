{inputs, ...}: {
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = inputs.nixvirt.lib.domain.writeXML (inputs.nixvirt.lib.domain.templates.linux {
        name = "haos";
        memory = {
          count = 4;
          unit = "GiB";
        };
      });
    }
  ];
}
