{ pkgs, ... }:
{
  nixpkgs.config.cudaSupport = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true; 
  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];
  hardware.nvidia-container-toolkit.enable = true;
}