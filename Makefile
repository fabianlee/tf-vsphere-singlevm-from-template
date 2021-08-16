THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)
TF := terraform

apply: init 
	$(TF) apply -auto-approve

init: 
	# skips init if .terraform directory already exists
	[ -d .$(TF) ] || $(TF) init

destroy:
	$(TF) destroy -auto-approve
	./clean-known-hosts.sh
	#rm terraform.tfstate*

refresh:
	$(TF) refresh
	$(TF) output
