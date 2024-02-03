export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=

export ECR=032566931471.dkr.ecr.us-east-1.amazonaws.com/app-repo ***
export DBHOST=172.18.0.2
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
export APP_COLOR=blue  ***

docker run -d -e MYSQL_ROOT_PASSWORD=pw --name mydb --network revati-nw ${ECR}:v0.1

docker run -p 8080:8080 --name lime --network revati-nw -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:v0.1

docker run -p 8081:8080 --name blue --network revati-nw -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR={APP_COLOR} ${ECR}:v0.1

docker run -p 8082:8080  --name pink --network revati-nw -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR={APP_COLOR} ${ECR}:v0.1
