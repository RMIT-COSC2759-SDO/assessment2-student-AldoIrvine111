# Servian TechTestApp
Student ID: S3692192 
Name: Aldo Irvine

This is a documentation for ACME corp. project. 
Previously, we manually deploy the app using ClickOps, this method is prone to human error,so ACME corp. decide to automate the infrastructre and deployment of the application. ACME corp. would like to automate their project using an open source application written in Golang.

In this new project, we will be using 4 tools to integrate the project from manually deploy to automated deploy.
The tools we using are Terraform, AWS, Ansible and CircleCi.

### 1. Terraform
Terraform is a provisioning infrastructure tool, like building, changing, and versioning. It as an AWS Partner Network (APN) Advanced Technology Partner and member of the AWS DevOps Competency, hence why this tool is choosen. 

### 2. AWS
Amazon Web Services, or more likely known as AWS, is a secure cloud services platform. It offer lots of service that help businesses scale and grow. Some of the services we will be using is EC2, where we will make and store our Virtual Machine (VM), RDS, for our databases, VPC, where we will use it to isolate our resources and secure them.

### 3. Ansible
Ansible is a simple open source IT automation engine. It automates cloud provisioning, configuration management, application deployment, intra-service orchestration and many more services. In this project, we will use it to deploy app in our VM that we made with terraform and store it in AWS.

### 4. CircleCI
CircleCI is an Continuous Integration tools. This help developer to integrate their code into a master branch of a shared repo early and often.

## dependencies
### 1. Create a VPC using Terraform with 3 layers across 3 availability zones(9 subnets). Public, Private, and Data
Before we move to our first step, we have to initialize aws in our main.tf by providing [provider "aws"{...].
Now we can start.
First, we will create Virtual Private Cloud (VPC) with 3 layers (Public,Private and Data) with 3 Availability zones. The total would be 9. We are creating the network that we will be deploying into other services.
We will code VPC in the vpc.tf
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/vpc1.PNG)

After every code, we will use terraform validate, terraform fmt and terraform plan. To make it easier, I used a makefile and store it as a script as make plan. Then, we will terraform apply --auto-approve to up it into AWS or I have scripted it as make up.

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/vpc_aws.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/makefile.PNG)

Now everything work, we will move on to make internet gateway. We need IGW so we can connect to and from the services we deploy in our VPC. We will deploy it agian and see that we have made the changes
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/igw1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/igw_aws.PNG)

The next step would be making the Default Route Table. We need to update the default route in the VPC so AWS knows to send internet bound traffic to the IGW. 
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/route-table.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/route_aws.PNG)

Now that we have configured the IGW and Route table, we can make 9 subnets which divided into 3 zone per layer. The reason we divided it to 9 different subnet is to have redundancy in case there is outage in AWS.
We will deploy it into 3 layer. Public , Private and Data. Each layer will be assigned to different services
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/public1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/private1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/data1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/subnet_aws.PNG)

### 2. Create 3 layer application infrastructure using Terraform
Before we start with deploying apps, we have several things to set up beforehand.First, we need to set up a key pair so we can access into the instances. We will create terraform.tfvars and store the variable inside. After that, we will create variables.tf and register variable called public_key of type string. Next we will put in the public key.
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/pkey1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/pkey2.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/pkey3.PNG)

Second things we will do is set up the security group for our application, we need to configure this so we can add it to the instances as they are created as part of the auto scaling group.

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/acs.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/acs_aws.PNG)

Next up we will create the config for launching new EC2 instances in the Auto Scaling Group.
A launch config needs to know which AMI to deploy, so we will add that into the terraform.tfvars and create new variables.tf file.
Next up, we will add the launch config based oon the resource section in the example in the doco.

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/ami1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/ami2.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/ami3.PNG)

We will make target group for load balancer, as we need to register that with the auto scaling group so we will create all the dependencies first.

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/tg.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/tg_aws.PNG)



## deploy instructions
#### 1. Load Balancer (Public Layer)
We will create an application load balancer. Make sure to make it external and assign the security group we created earlier for. Don't forget to assign it to be deployed in 3 public subnets.
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/lb.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/lb_aws.PNG)
We will create an ouput so that it is available in the command line. Create some code inside output.tf. And don't forget to make up to see the outputs.
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/lb_output.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/lb_console.PNG)

### 2. EC2 Instance (Private Layer)
Now that we have created all the pre-requisite for auto scaling group, we will create and run some instances.
We will reference both target group and launch configuration. This will be deployed in 3 private subnets
====PICTURE HERE==== CODE
====PICTURE HERE==== AWS

### 3. Database (Data layer)
We will initialized DB with db subnet group and store it into 3 data subnets.


Next we will create the DB with some details, such as db engine, version, name, username and etc. 
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/db_aws.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/db_output.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/db_output2.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/db1.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/db2.PNG)


Now that we create all of the db, we will output the db uname, db password, db endpoint. This output will be used for next task.

### 4. Automate deployment of the application to the deployed ec2 instance. Set up an ansible playbook that deploys and configure the application on the EC2 instance
#### 1. Automatically generate the inventory file.
Before starting to make the inventory.yaml file in ansible, we need to make a template which will be the public ip of our instance. Create a inventory.tpl with inventory.yaml structure and change the host into an input variable from the instances. We do this because the IP is not static everytime we run terraform, IP will change everytime we terraform destory and terraform apply a new one.
====PICTURE HERE==== AWS

 Hence why we should take it as variable from the output we made. On the output, we will create a data that will fetch the ip automatically and store it into an output. By then, we could get the IP dynamically without having to type it in.


Now, we can start making the invetory.yaml file. We will run this through run_ansible.sh. We will use ">>" to redirect the output we made before, into inventory.yaml. This way, inventory.yaml will be generated through script with the IP inside.


##### 2. Download the application and copy it to the local drive
After having the public IP of our instances, we will run the run_ansible.sh which contain playbook.yaml
We will mainly configure our instance with ansible through playbook.yaml. We should try to ssh to our instances and try the connection before configuring it with ansible. "ssh -i {your public key} ec2-user@{IP ADDRESS}. Our public key is stored locally inside our machine, usually the directory would be ~/.ssh/id_rsa.pub


Now that we know we are securely connected to our instances, we can start configuring playbook.yaml.
We will download the application and copy it to the local drive.
The first step would be creating directory which we will store our application. It would be easier to create and run code if we are a root. So, we gave it a "sudo" permission on the start of every of our command.
We will make the directory at /etc/TechTestApp. Since the application we are downloading is a zip file, we will unarchieve it then store it to the directory we have made before. It should now be available once we run the run_ansible.sh script again. We should always run the script again if we make changes in the playbook.yaml.
Once it is done, we can try to ssh and check it again.


#### 3. Configure the application with correct database output. (Automaticcaly fed in)
With the same principle as the first step, we will configure the application with the database credentials which we could fetch from output and append it into conf.toml of the applications. We will make a template which we would call db-config.tpl. Inside of the template, would be the credential we will fetch from output.tf. Now in to output.tf, we will make a data that fetch db credential from the AWS we created before, and output that data. Since we had a template, the output would print the credential according to the template we had madde. With this output, we will store it into our application conf.toml, this can be done through playbook.yaml.



On playbook.yaml, we create a new task to update db credential. We would use pipe command because we have more than one command we would run. We will now cd to infra because that is where we store our output, and run terraform output db_update, this command will specificaly print the output of db_update(which our credential is stored) and we will register that as db_output in our EC2 instances. After that we will copy the content of db_output, and set the destination to where our conf.toml is stored. Now that we have done configuring the playbook, re-run the script and ssh the instances to verify the changes.



#### 4. Set the application up as a service using SystemD so it will automatically start if the server is rebooted
We have to make a techtestapp.tpl in order to create a .service file. In the template file, we will specify what this .service file execute everytime the instance is booted, which is ./TechTestApp serve. We have to assigned this as a root command to avoid the command to be denied access, we will specify the working directory as well.


 Now that we have the template ready, we will start configuring playbook.yml again. After the task we create db credential, we will create another task that automatically start .service file everytime the instances is rebooted using systemD.

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_app.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_con.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_config.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_dbcon.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_output.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_toml.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbookdb.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/ingressupdatedb.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/inv_out.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/inv_script.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/playbook_tpl.PNG)

![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/service.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/ssh1.PNG)


All configuration is done and now we run the script again. Then we will enter the public IP of the instances in web browser and we can see that the application is running on our instances.

### Automate database instance
We will be using updatedb-s to update the db, we will add a new task for it in our playbook.yml and add a new security group for in and out http for database.
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/updatedb.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/updatedb1.PNG)

### Remote backend
By default Terraform use local backend, we change it into S3 and DynamoDB. We will terraform init again since we will use S3 
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/dynamo.PNG)
![repo images](https://github.com/RMIT-COSC2759-SDO/assessment2-student-AldoIrvine111/blob/master/pic/s3.PNG)

## cleanup instructions
Just terraform destory --auto-approve in infra directory.