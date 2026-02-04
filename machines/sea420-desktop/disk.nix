{ ... }:

{
  disko.devices = {
    disk.disk1 = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_1TB_S1D9NSAF535619D";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "disk1-luks";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
  };
}