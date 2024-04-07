{ ...
}:

{
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 224 ];
        events = [ "key" "rep" ];
        command = "/run/current-system/sw/bin/light -T 0.7";
      }
      {
        keys = [ 225 ];
        events = [ "key" "rep" ];
        command = "/run/current-system/sw/bin/light -A 5";
      }
    ];
  };
}
