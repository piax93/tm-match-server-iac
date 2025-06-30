TF_PROJECT ?= hetzner
TF_VARS_FILE ?= terraform.tfvars

.PHONY: install-hooks
install-hooks:
	python3 -m pre_commit install -f --install-hooks
	python3 -m pre_commit run --all-files

.PHONY:plan
plan:
	cd $(TF_PROJECT) \
	  && terraform init -upgrade \
	  && terraform plan -var-file=../$(TF_VARS_FILE)

.PHONY: apply
apply:
	cd $(TF_PROJECT) \
	  && terraform apply -var-file=../$(TF_VARS_FILE)
