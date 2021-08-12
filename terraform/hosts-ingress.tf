data "openstack_images_image_v2" "ingress-image" {
  name        = "illume-ingress"
  most_recent = true
}

data "openstack_blockstorage_volume_v3" "condor-queue" {
  name = format("%s%s", (var.testing == true ? "TEST-" : ""), "condor-queue")
}

resource "openstack_blockstorage_volume_v3" "ingress-volume" {
  name = format("%s%s", (var.testing == true ? "TEST-" : ""), "ingress-volume")
  size = "250"
  image_id = data.openstack_images_image_v2.ingress-image.id
}

resource "openstack_compute_instance_v2" "illume-ingress-v2" {
  name = format("%s%s", (var.testing == true ? "TEST-" : ""), "illume-ingress-v2")
  flavor_name = "c10-128GB-1440"
  key_pair    = "illume-new"
  security_groups = [format("%s%s", "illume-internal", (var.testing == true ? "" : "-v2")), "illume"]
  depends_on = [ openstack_compute_instance_v2.illume-control-v2 ]

  # boot device (volume)
  # Use a small size as we will mount the NFS with the larger storage
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.ingress-volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  # Check out this article for creating a shared dir for podman images:
  # https://www.redhat.com/sysadmin/image-stores-podman

  # Assign all ephemeral storage for this flavor (1440GB),
  # then split it up into partitions.
  block_device {
    boot_index            = -1
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "blank"
    volume_size           = 1440
  }

  metadata = {
                "prometheus_node_port": 9100,
                "prometheus_node_scrape": "true"
  }
  
  network {
    name = var.network
  }

  user_data = local.ingress-template
}

# Attach the condor-queue volume
resource "openstack_compute_volume_attach_v2" "condor-queue-volume" {
  instance_id = openstack_compute_instance_v2.illume-ingress-v2.id
  volume_id = data.openstack_blockstorage_volume_v3.condor-queue.id
}

// # Get the reference to the floating IP we want to use...
// data "openstack_networking_floatingip_v2" "illume-ingress-v2" {
//   pool = var.floating_ip_pool
// }

// # ...and attach it
// resource "openstack_compute_floatingip_associate_v2" "illume-ingress-v2" {
//   floating_ip = data.openstack_networking_floatingip_v2.illume-ingress-v2.address
//   instance_id = openstack_compute_instance_v2.illume-ingress-v2.id
// }

