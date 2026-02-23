{ ... }:
{
    # NFS server
    systemd.tmpfiles.rules = [
        "d /srv/nfs        0755 root root -"
        "d /srv/nfs/consw  0755 root root -"
    ];

    services.nfs.server = {
        enable = true;
        exports = ''
            /srv/nfs        *(ro,fsid=root,no_subtree_check)
            /srv/nfs/consw  *(rw,no_root_squash,no_subtree_check)
        '';
    };
    networking.firewall.allowedTCPPorts = [ 2049 ];
    networking.firewall.allowedUDPPorts = [ 2049 ];
}