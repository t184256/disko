# nix-instantiate --strict --json --eval format.nix | jq
{
  type = "table";
  format = "gpt";
  partitions = [
    {
      type = "partition";
      part-type = "ESP";
      start = "1MiB";
      end = "1024MiB";
      fs-type = "fat32";
      bootable = true;
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
      };
    }
    {
      type = "partition";
      part-type = "primary";
      start = "1024MiB";
      end = "100%";
      content = {
        type = "luks";
        algo = "aes-xts...";
        name = "crypted";
        keyfile = "/tmp/secret.key";
        content = {
          type = "lvm";
          name = "pool";
          lvs = {
            root = {
              type = "lv";
              size = "10G";
              mountpoint = "/";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            home = {
              type = "lv";
              size = "10G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    }
  ];
}
