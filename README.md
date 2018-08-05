### ewsdocker/debian-base

**ewsdocker/debian-base** is a version of the [nimmis/docker-ubuntu](https://github.com/nimmis/docker-ubuntu) docker image modified for use with **Debian 9**.  It adds several system utilities and libraries that are nominally required to properly utilize the **library/debian** docker image, and adds system initialization and supervisor functions for better control.  

______  

A pre-made docker image of **ewsdocker/debian-base** is available from [ewsdocker/debian-base](https://hub.docker.com/r/ewsdocker/debian-base/) at [Docker Hub](https://hub.docker.com).  
______  


**Installing ewsdocker/debian-base**  

The following scripts will download the the selected **ewsdocker/debian-base** image, create a container, setup and populate the directory structures, create the run-time scripts, and install the application's desktop file(s).  

The <i>default</i> values will install all directories and contents in the <b>docker host</b> user's home directory (refer to <a href="#mapping">Mapping docker host resources to the docker container</a>, below).  

**ewsdocker/debian-base:9.5.0**
  
    docker run --rm \
               -v ${HOME}/bin:/userbin \
               -v ${HOME}/.local:/usrlocal \
               -e LMS_BASE="${HOME}/.local" \
               -v ${HOME}/.config/docker:/conf \
               -v ${HOME}/.config/docker/debian-base-9.5.0:/root \
               --name=debian-base-9.5.0 \
           ewsdocker/debian-base:9.5.0 lms-setup  

____  

**Running the installed scripts**

After running the above command script, and using the settings indicated, the docker host directories, mapped as shown in the above tables, will be configured as follows:

 - the executable scripts have been copied to **~/bin**;  
 - the application desktop file(s) have been copied to **~/.local/share/applications**, and are availablie in any _task bar_ menu;  
 - the associated **debian-base-"version"** executable script (shown below) will be found in **~/.local/bin**, and _should_ be customized with proper local volume names;  

____  

**Executable scripts**  

**ewsdocker/debian-base:9.5.0**  
  
    docker run -d \
           --rm \
           -v /etc/localtime:/etc/localtime:ro \
           -v ${HOME}/workspace-base-9.5.0:/workspace \
           -v ${HOME}/.config/docker/debian-base-9.5.0:/root \
           --name=debian-base-9.5.0 \
       ewsdocker/debian-base:9.5.0  

____  


**Simple tests**  

**Test 1**  
Copy the docker command above (**Creating a container**) and paste it into a docker host command line to create a temporary docker container named *base*.  The docker container will display it's startup status, something like this:  

    docker exec -it -t debian-base-9.5.0 /bin/bash 


Press the Ctrl/C combination and the container should exit, something similar to  

    *** Shutting down supervisor daemon (PID 6)...  
    sh: 1: ps: not found  
    *** Killing all processes...  

______  

**locale**  

The following locale is automatically created in the image:  

    locale-gen en_US
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX  
  
This setting may be changed in the Dockerfile (using the RUN command) when building a new container from the **ewsdocker/debian-base** image. 

------

**Packages**  

Among the additional packages are   

  - **apt**
  - **apt-transport-https**  
  - **cron** 
  - **curl**
  - **git**
  - **less**
  - **libcurl3-gnutls**
  - **locales**
  - **logrotate** 
  - **lsb_release**
  - **nano** 
  - **patch** 
  - **psmisc**
  - **software-properties-common**
  - **sudo** 
  - **supervisor**
  - **syslog-ng** 
  - **syslog-ng-core** 
  - **unzip** 
  - **wget** 
  - **zip**

______  

**Documentation**  

Documentation for this docker image is provided by the original [nimmis/docker-ubuntu](https://github.com/nimmis/docker-ubuntu) docker image documentation at https://github.com/nimmis/docker-ubuntu.  

When following the narrative, replace [nimmis/docker-ubuntu](https://github.com/nimmis/docker-ubuntu) with **ewsdocker/debian-base**, and **ubuntu** with **debian**.  The provided functions and utilities are identical to the original image, except that they are being run under **Debian**.  
