output "org_storage_pool_name" {
  description = "Name of the organization storage pool"
  value       = module.org_storage_pool.pool_name
}

output "org_storage_pool_id" {
  description = "ID of the organization storage pool"
  value       = module.org_storage_pool.pool_id
}

output "org_network_name" {
  description = "Name of the organization network"
  value       = module.org_network.network_name
}

output "org_network_id" {
  description = "ID of the organization network"
  value       = module.org_network.network_id
}

output "cluster_nodes" {
  description = "List of objects for each cluster node with name, id, IP addresses, and MAC addresses"
  value       = module.kvm_cluster.cluster_nodes
}
