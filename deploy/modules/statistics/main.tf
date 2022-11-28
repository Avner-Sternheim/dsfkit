module "globals" {
  source         = "../../modules/core/globals"
  create_ssh_key = false
}

data "aws_caller_identity" "current" {}

# ################################
# Run Statistics scripts
# ################################
locals {
  statistics_cmds = templatefile("${path.module}/statistics.tpl", {
    statistics_bucket_name = "04274532-55f0-11ed-bdc3-0242ac120002"
    salt                   = module.globals.salt
    ip                     = module.globals.my_ip
    account_id             = data.aws_caller_identity.current.account_id
    user_id                = data.aws_caller_identity.current.user_id
    user_arn               = data.aws_caller_identity.current.arn
  })
}

resource "null_resource" "exec_statistics" {
  provisioner "local-exec" {
    command     = local.statistics_cmds
    interpreter = ["/bin/bash", "-c"]
  }
  triggers = {
    always_run = "${timestamp()}"
  }

}
