{ lib, ... }:

{
  # For better T480 CPU throttling, see https://github.com/erpalma/throttled
  services.throttled.enable = true;
}
