#!/bin/bash
#version 1.6
kernels='/kernels'

aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/ ;

echo -e "Latest kernel is:"  ;

chmod 644 index.html
#latest=`tail -n 5 index.html | grep href= | cut -c 81-89 `
latest=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3-`
echo $latest
echo $latest > latest


aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/ ;

all=`cat index.html | grep headers | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
headers=`cat index.html | grep headers | grep href= | sed -n 2p | cut -d">" -f2 | cut -d"<" -f1`
image=`cat index.html | grep image | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
modules=`cat index.html | grep modules | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`

echo -e $all "\n" $headers "\n" $image

cd ${kernels};
pwd
sleep 10;
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${all} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${headers} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${image} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${modules} --auto-file-renaming=false

chmod 744 ${all} ${headers} ${image} ${modules} 
