{ ...}:

{
  programs.light.enable = true;

  services.actkbd = {
    enable = true;
    bindings = [
      {
        events = [ "key" ];
        keys = [ 224 ];
        command = "/run/current-system/sw/bin/light -U 5";
      }
      {
        events = [ "key" ];
        keys = [ 225 ];
        command = "/run/current-system/sw/bin/light -A 5";
      }
    ];
  };
}
