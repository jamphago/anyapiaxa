#!/bin/bash
 
### MODIFY THESE VARIABLES
# $ 표시 붙은거는 여기에서 쓰는거  ${} , yaml 내 변경되어질 변수는 %변수% 로표시

# Refer the recent images in Docker registry or Docker hub
# Namespace
NAMESPACE=sf21



## Recent Images
echo "======== anylink_gateway image ========" 
curl -X GET http://192.168.103.52:5000/v2/anylink_gateway/tags/list
echo "======== anylink_gateway ========"
curl -X GET http://192.168.103.52:5000/v2/anyapi-master/tags/list
echo "======== monitoring ========"
curl -X GET http://192.168.103.52:5000/v2/sf-monitoring-backend/tags/list
curl -X GET http://192.168.103.52:5000/v2/sf-monitoring-ui/tags/list
curl -X GET http://192.168.103.52:5000/v2/sfmonitoring-fluentd/tags/list

echo "======================================="

## gateway, gateway_master 
GATEWAY_MASTER_IMAGE='192.168.103.52:5000/anyapi-master:cloud2'

ANYLINK_GATEWAY_IMAGE='192.168.103.52:5000/anylink_gateway:21.0.141'

MOUNT_PATH='/var/log/gwlog' #gateway_pv.yaml mount path


# sfmonitering
MON_BACK_IMAGE='192.168.103.52:5000/sf-monitoring-backend:0.1'
MON_UI_IMAGE='192.168.103.52:5000/sf-monitoring-ui:0.2'

SFFLUENTED_IMAGE='192.168.103.52:5000/sfmonitoring-fluentd:21.0.0.0'
ELASTIC_HOST='192.168.103.52' #elastic ip


# elasticsearch image
ELASTICSEARCH_IMAGE='docker.elastic.co/elasticsearch/elasticsearch:7.10.2'


# elasticsearch-data-pv
WORKER_NODE_NAME='worker01'  #k8s worker node name

PV_MOUNTPATH='/root/data/elasticsearch'


## Change variables in yaml files

#kubectl create namespace ${NAMESPACE}
find ./ -name "*.yaml" -exec sed -i "s/%NAMESPACE%/${NAMESPACE}/g" {} \;



#gateway-master, gateway
sed -i "s|%GATEWAY_MASTER_IMAGE%|${GATEWAY_MASTER_IMAGE}|g" gateway_master_yaml/gateway_master_pod.yaml

sed -i "s|%MOUNT_PATH%|${MOUNT_PATH}|g" gateway/gateway_pv.yaml
sed -i "s|%ANYLINK_GATEWAY_IMAGE%|${ANYLINK_GATEWAY_IMAGE}|g" gateway/gateway_dep.yaml



#monitering
sed -i "s|%MON_BACK_IMAGE%|${MON_BACK_IMAGE}|g" monitoring/sf-monitoring.yaml
sed -i "s|%MON_UI_IMAGE%|${MON_UI_IMAGE}|g" monitoring/sf-monitoring.yaml

sed -i "s|%SFFLUENTED_IMAGE%|${SFFLUENTED_IMAGE}|g" monitoring/sf-fluentd.yaml
sed -i "s|%ELASTIC_HOST%|${ELASTIC_HOST}|g" monitoring/sf-fluentd.yaml



#elasticsearch
sed -i "s|%CLUSTER_NAME%|${CLUSTER_NAME}|g" Elasticsearch/elasticsearch-data-deployment.yaml
sed -i "s|%NODE_NAME%|${NODE_NAME}|g" Elasticsearch/elasticsearch-data-deployment.yaml
sed -i "s|%NODE_LIST%|${NODE_LIST}|g" Elasticsearch/elasticsearch-data-deployment.yaml
sed -i "s|%MASTER_NODES%|${MASTER_NODES}|g" Elasticsearch/elasticsearch-data-deployment.yaml
sed -i "s|%ELASTICSEARCH_IMAGE%|${ELASTICSEARCH_IMAGE}|g" Elasticsearch/elasticsearch-data-deployment.yaml

sed -i "s|%WORKER_NODE_NAME%|${WORKER_NODE_NAME}|g" Elasticsearch/elasticsearch-data-pv.yaml

sed -i "s|%CLUSTER_NAME%|${CLUSTER_NAME}|g" Elasticsearch/elasticsearch-master-deployment.yaml
sed -i "s|%NODE_NAME%|${NODE_NAME}|g" Elasticsearch/elasticsearch-master-deployment.yaml
sed -i "s|%NODE_LIST%|${NODE_LIST}|g" Elasticsearch/elasticsearch-master-deployment.yaml
sed -i "s|%MASTER_NODES%|${MASTER_NODES}|g" Elasticsearch/elasticsearch-master-deployment.yaml
sed -i "s|%ELASTICSEARCH_IMAGE%|${ELASTICSEARCH_IMAGE}|g" Elasticsearch/elasticsearch-master-deployment.yaml

sed -i "s|%PV_MOUNTPATH%|${PV_MOUNTPATH}|g" Elasticsearch/elasticsearch-data-pv.yaml

# Execute yaml files

echo "======== gateway_master ========"
kubectl create -f gateway_master_yaml/gateway_master_pod.yaml
kubectl create -f gateway_master_yaml/gateway_master_service.yaml
echo "================================"


# Create configmap
kubectl create configmap gateway-config --from-file ./gateway/defaultApiGateway21
kubectl create configmap gateway-cert --from-file ./gateway/cert.pem


echo "======== gateway ========"
kubectl create -f gateway/namespaces.yaml
kubectl create -f gateway/gateway_pv.yaml
kubectl create -f gateway/gateway_dep.yaml
kubectl create -f gateway/gateway_svc.yaml
echo "================================"



#for elastic_files in `ls Elasticsearch`
#do
#    echo "======== $elastic_files ========"
#        kubectl apply -f Elasticsearch/$elastic_files
#    echo "==============================="
#done


kubectl apply -f Elasticsearch/elasticsearch-master-deployment.yaml
kubectl apply -f Elasticsearch/elasticsearch-data-pv.yaml
kubectl apply -f Elasticsearch/elasticsearch-data-deployment.yaml

echo "============waiting for monitoring pods=============="
sleep 60


for monitoring_files in `ls monitoring`
do
    echo "======== $monitoring_files ========"
        kubectl apply -f monitoring/$monitoring_files
    echo "==============================="
done




echo "===All Pods,Deployments,Services,PV,PVC,Statefulsets Successfully Created ==="




