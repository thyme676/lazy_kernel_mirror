#!/bin/bash
kernels='kernels'

numCompare() {
#   awk -v n1="$1" -v n2="$2" 'BEGIN {printf "%s " (n1<n2?"<":">=") " %s\n", n1, n2}'
if (( $(awk -v d1="$1" -v d2="$2" 'BEGIN {print ("'$d1'" >= "'$d2'")}') )); then
    echo "1" # yes it is
else
    echo "0" # no it is not
fi
}

aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/ ;

echo -e "Latest kernel is:"  ;

chmod 644 index.html
#latest=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3-`
last=`tail -n 5 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | cut -d"." -f2-`
second_last=`tail -n 6 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | head -n 1 | cut -d"." -f2-`
major=`tail -n 6 index.html | grep href= | cut -d"/"  -f5 | cut -c 3- | head -n 1 | cut -d"." -f1`

ret=`numCompare $second_last $last`
if [ $ret -eq 0 ]; then
    latest=`echo v${major}.${second_last}`
else
    latest=`echo v${major}.${last}`
fi

echo $latest
echo $latest > latest


aria2c -q -x 16 --allow-overwrite=true  http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/ ;

all=`cat index.html | grep headers | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
headers=`cat index.html | grep headers | grep href= | sed -n 2p | cut -d">" -f2 | cut -d"<" -f1`
image=`cat index.html | grep image | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`
modules=`cat index.html | grep modules | grep href= | sed -n 1p | cut -d">" -f2 | cut -d"<" -f1`

echo -e $all "\n" $headers "\n" $image

[ -d kernels ] || mkdir kernels
chmod 744 kernels
cd ${kernels};
pwd
sleep 10;
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${all} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${headers} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${image} --auto-file-renaming=false
aria2c  -x 16 http://kernel.ubuntu.com/~kernel-ppa/mainline/${latest}/${modules} --auto-file-renaming=false

chmod 744 ${all} ${headers} ${image} ${modules} 
