FROM python:3.8-buster


USER root

COPY . .
WORKDIR ./

EXPOSE 8000

RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN apt-get update
RUN apt-get install -y vim net-tools
RUN chmod 777 start-server.sh

#ENTRYPOINT ["java","-jar","-javaagent:/scouter/scouter.agent.jar", "-Dscouter.config=/scouter/conf/scouter.conf","/app.jar"]
CMD ./start-server.sh