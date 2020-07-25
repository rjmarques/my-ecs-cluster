## Terraform

The module defined in the `aws` subfolder has the following API

#### Inputs

- `region` - the aws region where the ECR repository will be created

#### Outputs

- `ecr_repository_url` - The aws region where the ECR repository will be created
- `container_definition` - The NGINX container definition, as a json string
- `secrets_arns` - This container has no secrets

## Nginx

I wanted users to be able to access my apps via HTTPS. But instead of me creating and managing my own certificates I decided to let [Certbot](https://certbot.eff.org/) take care of that. The latter will check, at startup, if new certificates are needed and will automatically alter the NGINX configuration to support the certificates it obtained.

Additionally, I defined a volume so that any certificates, keys, or other info used by Certbot can persist even if the container gets removed. This ensures no rate limiting is hit by having certbot try to issue certificates too frequently.
