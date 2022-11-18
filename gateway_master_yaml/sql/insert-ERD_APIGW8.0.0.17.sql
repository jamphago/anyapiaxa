SET SQL_SAFE_UPDATES = 0;

INSERT INTO APIGW_GW_GROUP (gw_group_id, gw_group_name) VALUES ('apigw-group', 'apigw-group');

INSERT INTO APIGW_INTEGRATED_USER (EMAIL, NAME, TYPE, ADMIN, PASSWORD, fail_count, created_at, modified_at) 
VALUES ("jeus", "ADMIN", "ADMIN", 1, "60637f9d5497d261e08976942cdd72df94a1d47b4c2dccbf87dd8591deac872f",0,"2022-06-23 15:24:37","2022-06-23 15:24:37");

INSERT INTO APIGW_GW_GROUP_CONFIG (GW_GROUP_ID, GW_CONFIG_TYPE, GW_CONFIG_DATA)
VALUES ("apigw-group", "AccessLogInfo", 
"{\"enable\":\"false\",\"format\":\"%h %l %u %t %r %s %b\",\"fileName\":\"access_log\",\"path\":\"default\",\"rotatetype\":\"TIMEBASE\",\"rotateparam\":\"daily\",\"times\":\"local\",\"expire\":\"none\"}");
INSERT INTO APIGW_GW_GROUP_CONFIG (GW_GROUP_ID, GW_CONFIG_TYPE, GW_CONFIG_DATA)
VALUES ("apigw-group", "GatewayBaseInfo", 
"{\"threadPoolMin\":\"10\",\"threadPoolMax\":\"100\",\"connectionTimeout\":\"3000\",\"readTimeout\":\"30000\",\"failoverTimeout\":\"60000\"}");
INSERT INTO APIGW_GW_GROUP_CONFIG (GW_GROUP_ID, GW_CONFIG_TYPE, GW_CONFIG_DATA)
VALUES ("apigw-group", "SystemLogInfo",
"{\"level\":\"info\",\"format\":\"[%Y-%m-%d %L%H:%M:%S][%P][%q][%[THREAD]]: %t\",\"compress\":\"false\",\"rotatetype\":\"TIMEBASE\",\"rotateparam\":\"daily\",\"times\":\"local\",\"expire\":\"none\"}" );