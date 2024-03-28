aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t sangacio-php -f ecrDocker/php.Dockerfile .
docker tag sangacio-php:latest 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-api:latest
docker push 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-api:latest

docker image rm sangacio-php 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-api

docker build -t sangacio-nginx -f ecrDocker/nginx.Dockerfile .
docker tag sangacio-nginx:latest 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-nginx:latest
docker push 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-nginx:latest

docker image rm sangacio-nginx 873153300908.dkr.ecr.ap-northeast-1.amazonaws.com/sangacio_app-dev-nginx
