# Oracle Communications Billing and Revenue Management (OCBRM) in Minikube (Kubernetes) Cluster

# Introduction
Oracle recently (Nov 2019) released Cloud Native OCBRM version. This project helps in setting up OCBRM locally (including Database) in a Minikube cluster for development/evaluation purpose.

## Software Compatibility

| Software | Version | Note |
| -- | -- | --|
| OCBRM | 12.0.0.2.0 ||
| Minikube | v1.6.2 | RAM: 10GB, Disk: 80GB |
| Kubectl | v1.17.0 | |
| Docker | 19.03.5 | |
| Helm | v3.0.2 | |

## Start Minkube

Make sure at least **10GB RAM** and **80GB Disk** is allocated. It may work with 8GB RAM. Please refer to Useful Tips section later.

```console
minikube start --memory 10240mb --disk-size=81920mb
```

## Download OCBRM Images

Download OCBRM images from: [edelivery.oracle.com](edelivery.oracle.com)

Oracle does not provide OCBRM images on hub.docker.com or own repository container-registry.oracle.com. So you need to download images separately and load into docker.

Login with your oracle.com account (you can create one for free). Seach for "Oracle Communications Billing and Revenue Management Cloud Native Deployment Option", accept Oracle license agreement, and download following modules:

  - oc-cn-brm-apps-12.0.0.2.0.tar
  - oc-cn-brm-batch-controller-12.0.0.2.0.tar
  - oc-cn-brm-batch-pipeline-12.0.0.2.0.tar
  - oc-cn-brm-cm-12.0.0.2.0.tar
  - oc-cn-brm-dm-aq-12.0.0.2.0.tar
  - oc-cn-brm-dm-eai-12.0.0.2.0.tar
  - oc-cn-brm-dm-ifw-sync-12.0.0.2.0.tar
  - oc-cn-brm-dm-invoice-12.0.0.2.0.tar
  - oc-cn-brm-dm-oracle-12.0.0.2.0.tar
  - oc-cn-brm-eai-js-12.0.0.2.0.tar
  - oc-cn-brm-init-db-12.0.0.2.0.tar
  - oc-cn-brm-invoice-formatter-12.0.0.2.0.tar
  - oc-cn-brm-realtime-pipeline-12.0.0.2.0.tar
  - oc-cn-brm-rel-12.0.0.2.0.tar

**NOTE**: Oracle Enterprise 12c image available on hub.docker.com is not suitable for OCBRM. The slim version (`store/oracle/database-enterprise:12.2.0.1-slim`) doesn't come with supported character set (AL32UTF8). The main (`store/oracle/database-enterprise:12.2.0.1`) version doesn't come partitioning feature enabled. So custom image is built and made available as `bhaskarkurapati/oracle-database:12.2.0.1-ee` on [hub.docker.com](hub.docker.com)

## Load OCBRM Images in Docker

**NOTE**: Minikube comes with own Docker inside it. OCBRM images should be loaded in Docker inside Minikube. For Mac, following command will point docker CLI to correct Docker.

```console
eval $(minikube docker-env)
```

Run following commands to load docker images in Docker.

```console
docker load -i <local-dir>/oracle-database-12.2.0.1-ee.tar
docker load -i <local-dir>/oc-cn-brm-apps-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-batch-controller-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-batch-pipeline-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-cm-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-dm-aq-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-dm-eai-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-dm-ifw-sync-12.0.0.2.0.tar 
docker load -i <local-dir>/oc-cn-brm-dm-invoice-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-dm-oracle-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-eai-js-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-init-db-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-invoice-formatter-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-realtime-pipeline-12.0.0.2.0.tar
docker load -i <local-dir>/oc-cn-brm-rel-12.0.0.2.0.tar
```

`<local-dir>` is where you downloaded OCBRM images.

Verify with `docker images` command to make sure that images are loaded in Docker.

**NOTE**: Since these images are very large (each 1-3 GB) and not available on public repositories, `imagePullPolicy` in this project is updated as `Never`. If you observe `ErrImagePull` in Kubernetes, most probably you missed above steps or loaded images in your local Docker instead of Docker inside Minikube.

## Create Namespaces in Kubernetes

Run following command from **project root directory**:

```console
kubectl apply -f 1-ocbrm-namespaces.yaml
```

It will create following Namespaces

| Namespace | Note |
| -- | -- |
| ocbrm-database | Oracle Enterprise 12c will be loaded in this namespace |
| ocbrm-init-db | OCBRM DB Initialization Scripts will be loaded in this namespace |
| ocbrm-application | OCBRM Application will be loaded in this namespace |

## Oracle Enterprise 12c Deployment

### Create `PersistentVolumeClaim` for Database

Due to ephemeral nature of Kubernetes, creating PVC PersistentVolumeClaim is needed to retain database data.

Run following command from **project root directory** to create PVC:

```console
kubectl apply -f 2-ocbrm-database-pvc.yaml -n ocbrm-database
```

Following PVC is created:

| PVC Name | Namespace | Note |
|--|--| --|
| database-persistent-volume-claim | ocbrm-database | PVC for database|

### Deploy Oracle Enterprise 12c Database

Run following command from **project root directory**:

```console
kubectl apply -f 3-oracle-database.yaml -n ocbrm-database
```

When database is deployed for the first time in cluster, it may take couple of minutes to initialized (~ 5 minutes). However, subsequent deployments should be fast. In either case, one can see the progress by using below command:

```console
kubectl -n ocbrm-database logs -f pod/<oracle-database-deployment-podname>
```

Wait until you see following in output before proceeding for next steps:

```console
#########################
DATABASE IS READY TO USE!
#########################
```

Database with following characteristic will be created:

| Property | Name |
| -- | -- |
| Container DB (CDB)| ORCLCDB |
| Portable DB (PDB) | ORCLPDB1 |
| Character Set| AL32UTF8 |

DB Admin Credentials:

| User ID | Password |
| -- | -- |
| SYS | Oradoc_db1 |

**NOTE**: This step downloads image from hub.docker.com. If bandwidth is a concern, after image is downloaded in Docker for the firs time, please save the image as a local file. Please refer to Useful Tips section later. Please remember to load the image as it is done for OCBRM images.

## OCBRM PIN User Creation in Database

OCBRM needs an application DB user created with certain privileges. You need to connect to Database POD to do following activities.

Run following command to get pod name:

```console
$kubectl -n ocbrm-database get pods
NAME                                        READY STATUS  RESTARTS AGE
oracle-database-deployment-698999cc48-xqpnw 1/1   Running 1        7h10m
```

Connect to POD:

```console
kubectl -n ocbrm-database exec -it pod/oracle-database-deployment-698999cc48-xqpnw bash
```

Execute following commands to create user, tablespaces, and required privileges to application DB user `pin`:

```console
connect sys/Oradoc_db1 as sysdba;
alter session set container=ORCLPDB1;
create tablespace pin00 datafile '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/pin00.dbf' size 600M reuse autoextend on default storage( initial 100K next 500K pctincrease 0 );
create tablespace pinx00 datafile '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/pinx00.dbf' size 400M reuse autoextend on default storage( initial 100K next 500K pctincrease 0 );
create temporary tablespace PINTEMP tempfile '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/pintemp.dbf' size 100M reuse autoextend on maxsize unlimited;

create user pin identified by "C1g2b3u#";
grant resource, connect, create synonym, create any synonym to pin;
alter user pin default tablespace pin00;
alter user pin temporary tablespace pintemp;
grant unlimited tablespace to pin;
grant execute on dbms_lock to pin;
grant alter session to pin;
grant execute on dbms_lock to pin;
grant execute on dbms_aq to pin;
grant execute on dbms_aqadm to pin;
grant select on sys.gv_$aq to pin;
grant create public synonym , create synonym , drop public synonym , create view , create sequence , create table , create any index , create procedure , resource, connect to pin;
```

Here is the summary:

| Property Name | Value | Note|
| -- | -- | -- |
| DB User | ID: pin </b>Password: C1g2b3u# | Use this password only. Otherwise none of clients (i.e. testnap) will be able to connect to CM! Looks like a bug in OCBRM |
| Pin DB | ORCLPDB1 | Portable DB |

## OCBRM Database Initialization (pin_setup)

`Helm` is used for deploying `init_db:12.0.0.2.0` module in Minikube.

Run following command from **htmlcharts** directory to deploy helm chart:

```console
helmcharts$ helm install ocbrm-init-db oc-cn-init-db-helm-chart --namespace ocbrm-init-db --values oc-cn-init-db-helm-chart/override-values.yaml
```

The database initialization takes around **30 minutes** to complete. Keep tailing POD logs until you see below message:

```console
helmcharts$ kubectl -n ocbrm-init-db get pods
NAME                     READY STATUS  RESTARTS AGE
init-db-596956f46d-xrr2f 1/1   Running 0        5h5m

helmcharts$ kubectl -n ocbrm-init-db logs -f pod/init-db-596956f46d-xrr2f
Oracle PKI Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Wallet password has been changed.
Oracle PKI Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Wallet password has been changed.
Operation is successfully completed.
Operation is successfully completed.
Operation is successfully completed.
Operation is successfully completed.
Operation is successfully completed.
Execute SQL statement from file /oms/sys/dd/data/post_modular_oracle.sql
Execute SQL statement from file /oms/sys/dd/data/create_indexes_collections_oracle.source
sox_unlock_service: Configuring database

PortalBase Schema has been initialized. Loading the unlock service stored procedure
Loading UnlockService stored procedure
UnlockService stored procedure loaded successfully
Starting create_obj()
Loading objects from file /oms/sys/dd/data/create_obj.source
Database Initialization successful
```

If you run into issues, you can uninstall with following command and try to install again:

```console
helmcharts$ helm uninstall ocbrm-init-db --namespace ocbrm-init-db
```

## OCBRM Deployment

### Create PVCs

OCBRM needs following PVCs to be pre-created in Minikube.

| PVC Name | Namespace |
| -- | -- |
| oms-rel-input | ocbrm-application |
| data | ocbrm-application |
| oms-uel-archive | ocbrm-application |
| outputreject | ocbrm-application |
| oms-uel-reject | ocbrm-application |
| oms-rel-archive | ocbrm-application |
| oms-uel-input | ocbrm-application |
| outputcdr | ocbrm-application |
| oms-rel-reject | ocbrm-application |
| brm-wallet-pvc | ocbrm-application |
| brm-payload-pvc | ocbrm-application |
| virtual-time | ocbrm-application |
| common-semaphore | ocbrm-application |

Please run following command from **project root directory** to create PVCs:

```console
kubectl apply -f 4-ocbrm-application-pvc.yaml -n ocbrm-application
```

Verify and wait until all PVCs are created:

```console
kubectl get pv
```

### Generate ocbrm.brm_crypt_key in base64 format

Further deployment steps depends on root key generated as part of pin_setup. Connect to pin@ORCLPDB1 database to get root key.

Run following command to get pod name:

```console
$kubectl -n ocbrm-database get pods
NAME                                        READY STATUS  RESTARTS AGE
oracle-database-deployment-698999cc48-xqpnw 1/1   Running 1        7h10m
```

Connect to POD:

```
kubectl -n ocbrm-database exec -it pod/oracle-database-deployment-698999cc48-xqpnw bash
```

Execute following commands get root key from pin@ORCLPDB1:

```console
[oracle@oracle-database-deployment-698999cc48-xqpnw ~]$ sqlplus pin@ORCLPDB1
SQL*Plus: Release 12.2.0.1.0 Production on Thu Jan 2 00:39:57 2020
Copyright (c) 1982, 2016, Oracle.  All rights reserved.
Enter password:
Last Successful login time: Wed Jan 01 2020 21:25:29 +00:00
Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production
SQL> select crypt_key from cryptkey_t;
CRYPT_KEY
--------------------------------------------------------------------------------
&ozt|F0845E2E730539ECDEED63EE0A93B6FC|83DA277D48374C9019AB35D171F8A5B46B8EA1D610
1B39D4D5EB2D6DA9246F3A52DB2794C839DA7D8A645AD2011ED7B3
SQL> quit
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production
[oracle@oracle-database-deployment-698999cc48-xqpnw ~]$ exit
```

Note down the `key` and exit from POD. Run following command to get key in base64 format:

```console
echo -n <key> | base64
```

For example:

**Key**: &ozt|F0845E2E730539ECDEED63EE0A93B6FC|83DA277D48374C9019AB35D171F8A5B46B8EA1D6101B39D4D5EB2D6DA9246F3A52DB2794C839DA7D8A645AD2011ED7B3
**Key in Base 64**: Jm96dHxGMDg0NUUyRTczMDUzOUVDREVFRDYzRUUwQTkzQjZGQ3w4M0RBMjc3RDQ4Mzc0QzkwMTlBQjM1RDE3MUY4QTVCNDZCOEVBMUQ2MTAxQjM5RDRENUVCMkQ2REE5MjQ2RjNBNTJEQjI3OTRDODM5REE3RDhBNjQ1QUQyMDExRUQ3QjM=

Update the base64 key in **oc-cn-helm-chart/override-values.yaml** file:

```yaml
    ...
    ...
    ENABLE_SSL: 1
    isSSLEnabled: true
    brm_crypt_key: Jm96dHxGMDg0NUUyRTczMDUzOUVDREVFRDYzRUUwQTkzQjZGQ3w4M0RBMjc3RDQ4Mzc0QzkwMTlBQjM1RDE3MUY4QTVCNDZCOEVBMUQ2MTAxQjM5RDRENUVCMkQ2REE5MjQ2RjNBNTJEQjI3OTRDODM5REE3RDhBNjQ1QUQyMDExRUQ3QjM=
    brm_root_pass: QzFnMmIzdSM=
    wallet:
        client: QzFnMmIzdSM=
    ...
    ...
```
   
### Deploy OCBRM Application

Run following command from **helmcharts** directory to deploy Helm chart:

```console
helmcharts$ helm install ocbrm oc-cn-helm-chart --namespace ocbrm-application --values oc-cn-helm-chart/override-values.yaml 
```

If you run into issues, you can uninstall with following command and try to install again:

```console
helm uninstall ocbrm --namespace ocbrm-application
```

Please wait until all PODs are in READY. It may take around **5 minutes** for all modules to start. During start up, some of the modules which depend on `cm` may restart multiple times. Its not a concern. Most probably they failed because CM (Connection Manager) was not up by the time these modules started.

```console
helmcharts$ kubectl -n ocbrm-application get pods
NAME                                 READY STATUS  RESTARTS AGE
batch-controller-64b48489fd-b47bk    1/1   Running 3        7m54s
batch-wireless-pipe-7c466c5f48-m2rts 1/1   Running 0        7m54s
brm-apps-944dcc4b6-8xkmv             1/1   Running 0        7m53s
cm-85595c45bf-8nn4v                  2/2   Running 1        7m53s
dm-aq-848d9f674-5sh7q                1/1   Running 0        7m54s
dm-eai-5667755c74-mv789              1/1   Running 0        7m54s
dm-ifw-sync-859fcf7c6b-xh6fc         1/1   Running 0        7m53s
dm-invoice-5db449d65-xj8g9           1/1   Running 0        7m54s
dm-oracle-54788dfbbf-lv76v           1/1   Running 0        7m54s
formatter-deploy-84ddd5564d-ntptn    1/1   Running 0        7m54s
realtime-pipe-8668c557cc-pnkgq       1/1   Running 0        7m54s
rel-daemon-79fc5465b8-cz2cv          1/1   Running 5        7m54s
helmcharts$
```

### Sanity Testing of OCBRM Deployment

`testnap` is deployed in container `cm` of `cm` POD. You need to login to `cm` container to use `testnap`.

```console
helmcharts$ kubectl -n ocbrm-application exec -it cm-85595c45bf-8nn4v -c cm bash
[omsuser@cm cm]$ cd /oms/sys/test
[omsuser@cm test]$ testnap
===> database 0.0.0.1 from pin.conf "userid"

nap(919)> r << XX 1
0 PIN_FLD_POID POID [0] 0.0.0.1 /dummy 1 0
0 PIN_FLD_MESSAGE STR [0] "Sanity test is successful!"
XX

nap(919)> xop PCM_OP_TEST_LOOPBACK 0 1
xop: opcode 11, flags 0
# number of field entries allocated 20, used 2
0 PIN_FLD_POID POID [0] 0.0.0.1 /dummy 1 0
0 PIN_FLD_MESSAGE STR [0] "Sanity test is successful!"

nap(919)> q
[omsuser@cm test]$exit
```

## Cleaning Up OCBRM

Cleaning up OCBRM is very simple! Delete all three namespaces. It will eventually delete all resources.

Run following command from **project root directory**.

```console
kubectl delete -f 1-oracle-database.yaml
```

<font color="red">**WARNING**</font>:  This is an irreversible activity. It will delete everything (database, application, PVCs) including data.

## Useful Tips

 - OCBRM images are very large. But you will anyway download it from [edelivery.oracle.com](edelivery.oracle.com). Keep backup of them to avoid again and again.
 - `bhaskarkurapati/oracle-database:12.2.0.1-ee` image is also large. After image is downloaded to Docker for the first time, run following command to save the image as a local file.

    ```console  
    docker save -o <local-dir>/oracle-database-12.2.0.1-ee.tar bhaskarkurapati/oracle-database:12.2.0.1-ee
    ```

 - Do not use `@` in DB passwords. You will get `ORA-12154: TNS:could not resolve the connect identifier specified` while starting `dm_oracle`.  `sqlplus` will connect fine!
 - If Database is installed outside Kubernetes/Minikube, OCBRM deployment can go with lesser RAM (say 6 ~ 8 GB). Make sure Characterset is AL32UTF8 and Partitioning is Enabled!
 - OCBRM Database Initialization is one-time activity. If Minikube is running out of resources, underlay init_db:12.0.0.2.0 pod.

    ```console	 
    helm uninstall ocbrm-init-db --namespace ocbrm-init-db
    ```


