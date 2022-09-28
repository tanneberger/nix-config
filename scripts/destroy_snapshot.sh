for s in $(zfs list -H -o name -t snapshot | grep @zfs-auto-snap_hourly); do zfs destroy $s; done
