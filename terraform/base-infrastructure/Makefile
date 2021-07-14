plan:
	$(TERRAFORM_CMD) init
	$(TERRAFORM_CMD) plan -var-file=./values.tfvars

apply:
	$(TERRAFORM_CMD) init
	$(TERRAFORM_CMD) apply -var-file=./values.tfvars

destroy:
	$(TERRAFORM_CMD) init
	$(TERRAFORM_CMD) destroy -var-file=./values.tfvars
