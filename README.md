# TrackMania Match Server IaC

Infra-as-code setup to easily launch Trackmania servers for tournaments.

Right now this just support spinning stuff up in [Hetzner Cloud](https://www.hetzner.com/cloud),
which is really cheap and minimal in features, but the idea is to have a setup generic enough
that could be recycled for many providers.

## How To

* Have [Terraform](https://developer.hashicorp.com/terraform) installed in your shell.
* Create a `terraform.tfvars` file following the [example file](terraform.tfvars.example),
  for every set of credentials provided one server will be created.
* Run `make plan` to ensure everything is looking alright.
* Run `make apply` to actually spin up the servers.
* All servers have Maniacontrol installed in them, and are connected to the same database,
  so you can set plugins and setting in one instance, and they will be replicated in all of them.
    * **NOTE**: remember to enable setting unlinking and turn off settings cache before doing any of that.
* Once you are done running the competition, empty the `dedi_credentials` list in `terraform.tfvars`,
  and run `make apply` again to delete all servers.
