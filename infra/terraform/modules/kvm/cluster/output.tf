output "cluster_nodes" {
  description = "List of objects for each cluster node with name, id, IP addresses, and MAC addresses"
  value = [
    for idx, n in module.cluster_nodes : {
      node_name        = n.domain_name
      node_id          = n.domain_id
      node_ip_address  = n.ip_addresses[0][0]
      node_mac_address = n.mac_addresses[0]
    }
  ]
}

