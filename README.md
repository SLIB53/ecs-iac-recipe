# ECS IaC Recipe

This project shows how to deploy a container on EC2 with ECS. The project uses a basic Node.js app in the [/app](./app) directory which conforms to the [Paketo Node.js Buildpack][paketo-nodejs].

# Usage

## Build

To build the server image and produce an artifact, use Buildpack from the [/app](/app) directory.

```sh
cd app
pack build my-service --builder paketobuildpacks/builder:base
```

## Deploy

To deploy the basic infrastructure, run `terraform init` and `terraform apply` from [/infra](/infra) directory.

```sh
cd infra
terraform init
terraform apply
```

Once this is complete, an ECR registry should be available. You can now push the server image to ECR and trigger a deployment.

```sh
docker tag my-service:latest `terraform output -raw my_service_repository_url`:latest
docker push `terraform output -raw my_service_repository_url`:latest
```

[paketo-nodejs]: https://paketo.io/docs/reference/nodejs-reference/
