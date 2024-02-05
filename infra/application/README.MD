export AWS_ACCESS_KEY_ID=ASIAQPFJD6AH3CL7BBFE
export AWS_SECRET_ACCESS_KEY=0hmNgPmJj3n4M27I6qsDEaU16OC/PzveICVbgWmV
export AWS_SESSION_TOKEN=FwoGZXIvYXdzENv//////////wEaDFARmb0JORpbATI+7iLGAYUlyla1ItcyJHkgc4Hv/ziFNM4pSZrAQ6+kKd4R8kdi+R4cO1KutpIJHYUJv5wENLdxEGvLpL5PqqeXMr5DmXLQ1I9NbAoO4FgLnSrwSQTsJBFL/ByqYHdxDcLKdmEKbL50uxCB2dXDre6mwkgwXJvAK2ANaBD7mr+1lh1uW5pRgDGu0mQeUzqml9PdqWPdM+Zkodwp2yCw3rttBlpbwzPNClsWu0KJBu+tfm5vlfbKk75PZ0b8YXxwA90K36rBGoNXZXBEUSiXnf+tBjItTkby1PDvGSVXpkSL4cOT2P9EDd5n2UiT+HU0+63oKkc50EYnPebFSkSzc8dP

export ECR=032566931471.dkr.ecr.us-east-1.amazonaws.com/app-repo
aws ecr get-login-password --region us-east-1 | docker login -u AWS ${ECR} --password-stdin
export DBHOST=172.18.0.2
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
export APP_COLOR=pink

docker run -d -e MYSQL_ROOT_PASSWORD=pw --name mydb --network NW-REVATI ${ECR}:v0.1

docker run -p 8080:8080 --name lime --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:v0.1

docker run -p 8081:8080 --name blue --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=${APP_COLOR} ${ECR}:v0.1

docker run -p 8082:8080  --name pink --network NW-REVATI -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=${APP_COLOR} ${ECR}:v0.1
