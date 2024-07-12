## Table of Contents
* [What is IAC?](#item1)
* [What is Terraform?](#item2)
* [Terraform File Structure](#item3)
* [Terraform Commands](#item4)
* [Terraform Installation](#item5)
* [Terraform Functions](#item6)
* [Control Structures](#item7)

<a name="item1"></a>
## What is IAC?

Infrastructure as Code (IAC) is a methodology that treats IT infrastructure as software, allowing for automated management and configuration of all resources in a technological infrastructure through code. Instead of manually configuring servers, networks, and other components, code is used to describe the desired infrastructure, which facilitates its deployment, maintenance, and scalability. Terraform has the ability to communicate through APIs with AWS, GCP, AKS, and other cloud platforms. For more information, visit https://registry.terraform.io/browse/providers

<a name="item2"></a>
## What is Terraform?

Terraform is an open-source tool developed by HashiCorp used to implement and manage infrastructures in an automated and declarative manner. It allows defining infrastructure as code in a specific language (HCL, HashiCorp Configuration Language), which facilitates the creation, modification, and deletion of resources in different cloud providers and on-premise environments in a consistent and reproducible way.

<a name="item3"></a>
## Terraform File Structure

In Terraform, the file structure typically includes:

- Main configuration files: such as `main.tf`, where the main resources and configurations are defined.
- Variable files: such as `variables.tf`, where variables used in the code are declared.
- Output files: such as `outputs.tf`, where outputs of created resources are specified.
- Provider configuration files: such as `providers.tf`, where cloud providers or services are configured.
- Other support files: such as `terraform.tfstate` (infrastructure state) and `terraform.tfvars` (variable values).

<a name="item4"></a>
## Terraform Commands

Some common Terraform commands include:

- `terraform init`: Initializes the working directory and downloads necessary providers and modules.
- `terraform plan`: Generates an execution plan that shows the changes to be applied to the infrastructure.
- `terraform apply`: Applies the changes defined in the Terraform code to the infrastructure.
- `terraform destroy`: Removes all resources managed by Terraform according to the configuration.
- `terraform validate`: Verifies the syntax and semantics of Terraform configuration files.
- `terraform state`: Allows managing the infrastructure state and performing advanced operations.

<a name="item5"></a>
## Terraform Installation

To install Terraform, please refer to the official documentation at https://developer.hashicorp.com/terraform/install

To install Terraform on a Linux system (Debian or Ubuntu), you can use the following commands:

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

<a name="item6"></a>
## Terraform Functions

Terraform provides a series of functions that can be used within configuration files to perform more advanced operations and manipulations. Here are some functions. For more details, visit https://developer.hashicorp.com/terraform/language/functions

- `abs`: Returns the absolute value of a number.
- `ceil`: Rounds a number up to the nearest integer.
- `cidrhost`: Obtains the IP address of a host within a CIDR subnet.
- `coalesce`: Returns the first non-null value from a list of values.
- `concat`: Concatenates two or more lists.
- `distinct`: Removes duplicate elements from a list.
- `flatten`: Converts a list of lists into a flat list.
- `keys`: Returns the keys of a map as a list.
- `length`: Returns the length of a list, set, or string.
- `lower`: Converts a string to lowercase.
- `map`: Creates a new map from another by applying a function to each key-value pair.
- `max`: Returns the maximum value from a list of numbers.
- `merge`: Combines multiple maps into one.
- `min`: Returns the minimum value from a list of numbers.
- `regex`: Performs a regular expression search on a string.
- `replace`: Replaces all occurrences of a substring in a string.
- `reverse`: Reverses the order of a list.
- `sort`: Sorts a list in ascending or descending order.
- `timestamp`: Returns the current timestamp in RFC3339 format.
- `upper`: Converts a string to uppercase.

<a name="item7"></a>
## Control Structures

Control structures are fundamental in Terraform for performing conditional, iterative, and data manipulation operations in configuration code, allowing for more dynamic and flexible management of infrastructure as code. Here are some control structures; there are many more in the documentation:

- `if and else structure`: Used to perform conditional operations based on a boolean expression.
- `for structure`: Allows iterations or loops to create multiple instances of a resource.
- `for_each structure`: Similar to for, but allows creating resource instances based on a set of keys and values.
- `dynamic structure`: Used to generate resources dynamically, especially useful for applying similar configurations to multiple resources.
- `each structure`: Used in combination with for_each to access the keys and values of a map during resource creation.
- `count structure`: Allows creating a specific number of instances of a resource based on a numerical value.
- `depends_on structure`: Establishes explicit dependencies between resources, ensuring that certain resources are created before others.
- `locals structure`: Allows defining local variables within the configuration block to reuse values.
- `terraform structure`: Used to configure general Terraform options, such as the required version.
- `provider structure`: Specifies the cloud service provider to be used in the project.
