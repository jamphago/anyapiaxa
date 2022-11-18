
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


