# debian-base

**ewsdocker/debian-base** is a version of the *nimmis/ubuntu* docker image modified for use with *Debian 9*.  It adds several system utilities and libraries that are nominally required to properly utilize the *library/debian:9.4* docker image, and adds system initialization and supervisor functions for better control.  

Among the additional packages are 
<ul>
  <li><b>apt</b></li>
  <li><b>apt-transport-https</b></li>  
  <li><b>cron</b></li> 
  <li><b>curl</b></li>
  <li><b>git</b></li>
  <li><b>less</b></li>
  <li><b>libcurl3-gnutls</b></li>
  <li><b>locales</b></li>
  <li><b>logrotate</b></li> 
  <li><b>nano</b></li> 
  <li><b>patch</b></li> 
  <li><b>psmisc</b></li>
  <li><b>software-properties-common</b></li>
  <li><b>sudo</b></li> 
  <li><b>supervisor</b></li>
  <li><b>syslog-ng</b></li> 
  <li><b>syslog-ng-core</b></li> 
  <li><b>unzip</b></li> 
  <li><b>wget</b></li> 
  <li><b>zip</b></li>
</ul>

Documentation for this docker image is provided by the original *nimmis/ubuntu* docker image documentation at  

  https://github.com/nimmis/docker-ubuntu

When following the directions, replace *nimmis/ubuntu* with **ewsdocker/debian:9.4**, and *ubuntu* with *debian*.  The provided functions and utilities are identical to the original image, except that they are being run under *Debian 9.4*.

------
### locale
The following locale is automatically created in the image:

    locale-gen en_US
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX  
  
This setting may be changed in the Dockerfile (using the RUN command) when building a new container from the **ewsdocker/debian-base** image, 

