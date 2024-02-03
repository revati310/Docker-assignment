export AWS_ACCESS_KEY_ID=ASIAQPFJD6AHULMOKP4D
export AWS_SECRET_ACCESS_KEY=yRKpiniEVrXP/yP5nCEbPUV6U++GpH0VH42+e/uh
export AWS_SESSION_TOKEN=FwoGZXIvYXdzEMf//////////wEaDJKWpL5Ar+aHGeUjjyLGASgTi2xLc7QPTwH2BcTLSvsVwPlXn+hwQwTaNjcETWn6xtxk7YNKNlpEXoaI51rzFL4LZ/5HVjzNjPns/gzqDc5brdMx/QudIKG2k+xVWA0BqyAARFFtfwL4OMgsQXFZOHawuaQtOaeWiZSZG6ibkzJ00f1G3QNiU1+O3DnGBcQupxDYGJrN+UcqGwr26lLIpzjjJ571FNLiLpv+Fis41JQ+U3eDGhNIGOD0WGkp4Bs1lXUvGLGzYuoRA9EbI4VlOoE0Wod6JSjw3PqtBjIt46cQ8Fz2yYdGYVXu2sRt4fz3PBWWcFIELmCxbgiLonOwURe1sS9u9+W6doIR

export ECR=032566931471.dkr.ecr.us-east-1.amazonaws.com/app-repo ***
aws ecr get-login-password --region us-east-1 | docker login -u AWS ${ECR} --password-stdin
export DBHOST=172.18.0.2
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
export APP_COLOR=pink ***

docker run -d -e MYSQL_ROOT_PASSWORD=pw --name mydb --network NW-REVATI ${ECR}:v0.1

docker run -p 8080:8080 --name lime --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:v0.1

docker run -p 8081:8080 --name blue --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=${APP_COLOR} ${ECR}:v0.1

docker run -p 8082:8080  --name pink --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=${APP_COLOR} ${ECR}:v0.1
