#!/bin/bash
# Copywright mark williams 2018
site=`cat site.txt`
aria2c -q -x 16 --allow-overwrite=true --auto-file-renaming=false ${site}/index.html ;

echo -e "Latest kernel is:"  ;

latest=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3-`
echo $latest
echo $latest > latest

all=`cat index.html | grep headers | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
headers=`cat index.html | grep headers | grep href= | sed -n 2p | cut -d">" -f2 | cut -d"<" -f1`
image=`cat index.html | grep image | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
modules=`cat index.html | grep modules | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`

echo -e $all "\n" $headers "\n" $image

aria2c  -x 16 --allow-overwrite=false --auto-file-renaming=false ${site}/kernels/${all} #&> /dev/null;
aria2c  -x 16 --allow-overwrite=false --auto-file-renaming=false ${site}/kernels/${headers} #&> /dev/null;
aria2c  -x 16 --allow-overwrite=false --auto-file-renaming=false ${site}/kernels/${image} #&> /dev/null;
aria2c  -x 16 --allow-overwrite=false --auto-file-renaming=false ${site}/kernels/${modules} #&> /dev/null;

result=$?
#echo $result
if [ $result -ne 0 ]; then
	echo "Already have the latest version local! :)"
	exit -1
fi

sudo dpkg -i *.deb


