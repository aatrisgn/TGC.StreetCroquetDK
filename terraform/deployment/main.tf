module "deployment_files" {
  source = "git::https://github.com/aatrisgn/TGC.templates/terraform/modules/deployment_file.git?ref=main"
  for_each = { for val in local.deployment_files : val => val }

  source_path = "${var.source_path}"
  destination_path = "${var.destination_path}"
  file_name = each.value
}