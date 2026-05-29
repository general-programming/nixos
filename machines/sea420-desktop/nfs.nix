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
        # Pin the NFSv3 helper daemon ports so they can be firewalled.
        lockdPort = 4001;
        mountdPort = 4002;
        statdPort = 4000;
    };
    networking.firewall.allowedTCPPorts = [
        111   # rpcbind / portmapper
        2049  # nfsd
        4000  # statd
        4001  # lockd
        4002  # mountd
    ];
    networking.firewall.allowedUDPPorts = [
        111   # rpcbind / portmapper
        2049  # nfsd
        4000  # statd
        4001  # lockd
        4002  # mountd
    ];
}