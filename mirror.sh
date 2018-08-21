#!/bin/bash
kernels='kernels'

numCompare() {
echo $1 $2 | awk ' BEGIN {print ($1 > $2) ? 1:0}'
}

aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/ ;

echo -e "Latest kernel is:"  ;

chmod 644 index.html
#latest=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3-`
last=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | cut -d"." -f2- | cut -d"-" -f1`
second_last=`tail -n 6 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | head -n 1 | cut -d"." -f2- | cut -d"-" -f1`
major=`tail -n 6 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | head -n 1 | cut -d"." -f1`

ret=`numCompare $second_last $last`
if [ -z "${last##*rc*}" ] ; then
    latest=`echo ${major}.${last}` # If bottom of page is rc, choose last kernel
elif [ $ret -eq 1 ]; then
    latest=`echo ${major}.${second_last}` # If the second to last is larger ex: 18 vs 18.1
else
    latest=`echo ${major}.${last}` # Latest must be latest kernel
fi

echo $latest

aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/ ;

all=`cat index.html | grep headers | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
headers=`cat index.html | grep headers | grep href= | sed -n 2p | cut -d">" -f2 | cut -d"<" -f1`
image=`cat index.html | grep image | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
modules=`cat index.html | grep modules | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`

echo -e $all "\n" $headers "\n" $image

[ -d kernels ] || mkdir kernels
chmod 755 kernels
cd ${kernels};
pwd
sleep 10;
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${all} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${headers} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${image} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${modules} --auto-file-renaming=false

chmod 755 ${all} ${headers} ${image} ${modules}
