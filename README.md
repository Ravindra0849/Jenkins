# Integrating Terraform code with GitLab CI/CD by using shared runners

GitLab: GitLab is a platform that developers use to store and collaborate on their code. It's like a virtual workspace for coding projects.

In Simple Words: GitLab CI/CD is a system that helps developers automatically check their code to catch errors and, if everything is okay, automatically release their software without manual work. It's like having robots that test and deliver your code for you, saving time and reducing errors.

--> Create an IAM role for ACCESS_KEY and SECRET_KEY

--> Create Terraform files and push it into the gitHub repo. if you need these files check it in my github repo. URL: https://github.com/Ravindra0849/Jenkins_Terraform.git

--> Goto Google and search for  Gitlab.com and Create an Account Here

--> Click on Blank Project, and Provide all the details

--> To add Access_key and Secret_key in gitlab 
    -   On left side click on settings
    -   click on CI/CD
    -   Click on variables and click on expand
    -   Add variables Here

--> Click to add new file in project, give name as .gitlab-ci.yml  and add this in the file
    
    stages: 
        - validate
        - plan
        - apply
        - destroy
    image:
        name: hashicorp/terraform:light
        entrypoint:
            - '/usr/bin/env'
            - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

--> This is for  before we need to execute the scripts for many times so, we need to delete the .terraform file and create  once again for that we need to add this scripts.

    before_script:
        - export AWS_ACCESS_KEY=${AWS_ACCESS_KEY_ID}
        - export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
        - rm -rf .terraform
        - terraform --version
        - terraform init

before_script:: This section defines commands to run before each job in the pipeline.

The first two lines export the AWS access key and secret access key as environment variables, which are used for AWS authentication in your Terraform configuration.

==> rm -rf .terraform: This removes any existing Terraform configuration files and state files to ensure a clean environment.

==> terraform --version: Displays the Terraform version for debugging and version confirmation.

==> terraform init: Initializes Terraform in the working directory, setting up the environment for Terraform operations.

    validate:
        stage: validate
        script:
            - terraform validate

--> validate:: Defines a job named "validate" in the "validate" stage. This job validates the Terraform configuration.

--> script:: Specifies the commands to run as part of this job. In this case, it runs terraform validate to check the syntax and structure of your Terraform files.

    plan:
        stage: plan
        script:
            - terraform plan -out=tfplan
        artifacts:
            paths:
                - tfplan

    apply:
        stage: apply
        script:
            - terraform apply -auto-approve tfplan
        dependencies:
            - plan

-->  apply:: This job, in the "apply" stage, applies the Terraform plan generated in the previous stage.

--> script:: Runs terraform apply -auto-approve tfplan, which applies the changes specified in the "tfplan" file.

--> dependencies:: Specifies that this job depends on the successful completion of the "plan" job.

    destroy:
        stage: destroy
        script:
            - terraform init
            - terraform destroy -auto-approve
        when: manual
        dependencies: 
            - apply

--> when: manual: Specifies that this job should be triggered manually by a user.

--> dependencies:: Ensures that this job depends on the successful completion of the "apply" job, meaning you can only destroy resources that have been applied by a prior "apply" job.

