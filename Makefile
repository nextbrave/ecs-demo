export TERRAFORM_CMD?=terraform
export TF_VAR_app_image_tag?=latest

app-build-and-push:
	$(MAKE) -C ./example-app build-and-push

app-build:
	$(MAKE) -C ./example-app build


base-infra-plan:
	$(MAKE) -C ./terraform/base-infrastructure plan

base-infra-apply:
	$(MAKE) -C ./terraform/base-infrastructure apply

base-infra-destroy:
	$(MAKE) -C ./terraform/base-infrastructure destroy

app-infra-plan:
	$(MAKE) -C ./terraform/example-app-deploy plan

app-infra-apply:
	$(MAKE) -C ./terraform/example-app-deploy apply

app-infra-destroy:
	$(MAKE) -C ./terraform/example-app-deploy destroy
