### Description

This is a dockerfile to run autossh inside a docker container and create ssh tunnels.

#### How to use it

The image is availablein docker hub:

```shell
docker pull lastko/docker-autossh
```
Or you can clone, fork or use it as a template and create your own image.

**Environment variables**:
* REMOTE_TARGET_HOST: Target host to connect within remote local network. Default localhost.
* REMOTE_TARGET_PORT: Target port to connect within remote local network.
* REMOTE_SSH_HOST: Remote host to create ssh connection. 
* REMOTE_SSH_PORT: Remote port to create ssh connection.
* REMOTE_SSH_USER: Remote user to use in ssh connection.
* LOCAL_PORT: Local port tu bind remote target port. Default same port set in REMOTE_TARGET_HOST
* LOCAL_HOST: To bind remote host. Default localhost.
* SSH_IDENTITY_FILE: if you want to use RSA file set here the path inside container. Default .ssh/id_rsa. Make sure you attach the file to the container.
* ARGS: Extra args for autossh command [[https://linux.die.net/man/1/autossh]]

If you have ssh acount in remoteHost (por 22) and you want to bind your local port 5432 with a postgres running in host 192.168.0.50 within remoteHost network (with no public ip):

```shell
docker run \
    --rm \
    --name=myContainer \
    --network myNetwork \
    -e REMOTE_TARGET_PORT=5432 \
    -e REMOTE_TARGET_HOST=192.168.0.50 \
    -e REMOTE_SSH_HOST=remoteHost \
    -e REMOTE_SSH_USER=ubuntu \
    -e ARGS="-M 0 -o StrictHostKeyChecking=no -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o AddressFamily=inet" \
    -e SSH_IDENTITY_FILE=/root/.ssh/id_rsa \
    -v /home/ubuntu/.ssh/id_rsa:/root/.ssh/id_rsa \
    lastko/docker-autossh
```

This command should create **myContainer**  reachable by any container running within **myNetwork**. You can connect to remote postgres with another container running in the same network using **postgresql://user:secret@localhost:5432** connection URI using credentials for remote connection (user:secret).
