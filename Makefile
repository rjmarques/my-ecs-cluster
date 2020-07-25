  
.SILENT: build deploy
all: build deploy 

build:
	echo "Building nginx image"
	docker build -t rjmarques/nginx ./nginx
	echo "Runnable docker image: rjmarques/nginx"	

deploy:
	echo "Deploying the nginx to ECS"
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR}
	docker tag rjmarques/nginx:latest ${ECR_NGINX_REPO}:latest
	docker push ${ECR_NGINX_REPO}:latest
	aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --region ${AWS_REGION} --force-new-deployment | cat