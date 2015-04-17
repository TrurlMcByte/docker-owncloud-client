# docker-owncloud-client
Owncloud headless client so I can run multiple owncloud-clients on one machine to dfferent owncloud servers :)

Image should install the latest client (currently 1.8.0)

```
*Usage: 
docker run -d -v <hostdirtosync:dockerdirtosync> <environment vars> \ 
         idef1x/docker-owncloud-client 

*Example : 
docker run -d \
   -v ~/mydocs:/mydocs 
   -e LOCALDIR="/mydocs" \ 
   -e USER="example" \
   -e PASSWORD="examplepassword" \
   -e URL="https://<owncloudserver_name>/owncloud/remote.php/webdav/mydocs" \  
   -e INTERVAL="30" \
   -e HOSTUSER="myuserid" \ 
   --name <container name> \
   idef1x/docker-owncloud-client
```

# Environment vars to use:
* USER => owncloud user
* PASSWORD => owncloud user password
* LOCALDIR => local (to docker client) directory to sync (create one with -v <hostdir>:<dockerdir> )
* URL      => owncloud server URL with remote directory to sync
* INTERVAL => interval to check for changes 
* HOSTUSER => user on host system so files get written by this user instead of root!

# Remarks
* if one of those environment variables are not available it won't work!
* naming the container (--name) is just for conveniance
* client will trust any https certificate, so you can use it with self-signed certificates as well
  so check the certificate of the server URL before yourself!
* Even when using a .netrc file for authenticating you can still see the credentials in the logs :(
  Probably has to do that the owncloud commandline is for testing only. 
