# ECS IaC Recipe

This project shows how to run a container on EC2 with ECS. Building and deploying the app will produce a container running a Node.js HTTP server on a public EC2 instance. The project uses a basic Node.js app that conforms to the [Paketo Node.js Buildpack][paketo-nodejs].

## Requirements

* [AWS][aws]
* [Docker][docker]
* [Pack][pack]
* [Terraform][terraform]

## Usage

### Build

To build the server image and produce an artifact, use `pack` inside the [/app](/app) directory.

```sh
cd app
pack build my-service --builder paketobuildpacks/builder:base
```

### Deploy

To deploy the infrastructure, use `terraform` inside the [/infra](/infra) directory.

```sh
cd infra
terraform init
terraform apply
```

Once that is complete, you are ready to deploy the app. To deploy the app, use `docker` to push the server image (see [build](#build)) to the deployed ECR repository.

```sh
docker tag my-service:latest `terraform output -raw my_service_repository_url`:latest
docker push `terraform output -raw my_service_repository_url`:latest
```

### Teardown

To remove the app and all of the infrastructure from AWS, use `terraform`.

```sh
cd infra
terraform destroy
```

## Troubleshooting

### AWS

Be sure to have your environment configured with an AWS account. The best way to do this is to install and configure [AWS CLI][aws-cli].

[pack]: https://buildpacks.io/docs/tools/pack/
[docker]: https://www.docker.com
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com
[paketo-nodejs]: https://paketo.io/docs/reference/nodejs-reference/
[aws-cli]: https://aws.amazon.com/cli/
