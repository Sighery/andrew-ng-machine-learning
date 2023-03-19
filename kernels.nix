{pkgs, ...}: {
  kernel.python.custom = {
    enable = true;
    extraPackages = ps: [ ps.numpy ps.matplotlib ];
  };
}
