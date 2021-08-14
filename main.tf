
locals {
  bin_dir = var.bin_dir != "" ? var.bin_dir : "${path.cwd}/bin"
}

resource null_resource setup-jq {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-jq.sh '${local.bin_dir}'"
  }
}

resource null_resource setup-igc {
  depends_on = [null_resource.setup-jq]

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-igc.sh '${local.bin_dir}'"
  }
}

resource null_resource setup-yq3 {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-yq3.sh '${local.bin_dir}'"
  }
}

resource null_resource setup-yq4 {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-yq3.sh '${local.bin_dir}'"
  }
}
