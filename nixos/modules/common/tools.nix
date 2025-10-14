{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bandwhich # tui to see where bandwith is going
    ethtool # stats about network interface (e.g. dropped packets)
    gdb # debugger
    htop # system monitor tui
    perf # performance profiler
    lsof # list open files/processes
    net-tools # netstat
    nmap # port and IP scanner
  ];
}
