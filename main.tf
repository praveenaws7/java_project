name: 'GCP Terraform'

on:
  push:
    branches: [ "main" ]
  workflow_dispatch:

permissions:
  contents: read
  id-token: 'write'

jobs:
  checkout:
    name: 'Checkout Code'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

  authenticate:
    name: 'Authenticate Google Cloud'
    runs-on: ubuntu-latest
    needs: checkout  # This job depends on the 'checkout' job
    steps:
      - name: Authenticate Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.SERVICE_ACCOUNT_EMAIL }}

  setup_terraform:
    name: 'Setup Terraform'
    runs-on: ubuntu-latest
    needs: authenticate  # This job depends on the 'authenticate' job
    steps:
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

  terraform_fmt:
    name: 'Terraform Format'
    runs-on: ubuntu-latest
    needs: setup_terraform  # This job depends on the 'setup_terraform' job
    steps:
      - name: Terraform Fmt
        run: terraform fmt -check -diff

  terraform_init:
    name: 'Terraform Init'
    runs-on: ubuntu-latest
    needs: terraform_fmt  # This job depends on the 'terraform_fmt' job
    steps:
      - name: Terraform Init
        run: terraform init 

  terraform_validate:
    name: 'Terraform Validate'
    runs-on: ubuntu-latest
    needs: terraform_init  # This job depends on the 'terraform_init' job
    steps:
      - name: Terraform Validate
        run: terraform validate

  terraform_plan:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    needs: terraform_validate  # This job depends on the 'terraform_validate' job
    steps:
      - name: Terraform Plan
        run: terraform plan -input=false

  terraform_apply:
    name: 'Terraform Apply'
    runs-on: ubuntu-latest
    needs: terraform_plan  # This job depends on the 'terraform_plan' job
    steps:
      - name: Terraform Apply
        run: terraform apply --auto-approve -input=false

  terraform_destroy:
    name: 'Terraform Destroy'
    runs-on: ubuntu-latest
    needs: terraform_apply  # This job depends on the 'terraform_apply' job
    steps:
      - name: Wait for 30 seconds before destroy
        run: |
          echo "Sleeping now for 30 seconds before destroy..."
          sleep 30

      - name: Terraform Destroy
        run: terraform destroy -auto-approve -input=false
