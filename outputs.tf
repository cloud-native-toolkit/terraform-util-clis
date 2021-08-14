output "bin_dir" {
  description = "Directory where the clis were downloaded"
  value       = local.bin_dir
  depends_on  = [
    null_resource.setup-jq,
    null_resource.setup-igc,
    null_resource.setup-yq3,
    null_resource.setup-yq4
  ]
}
