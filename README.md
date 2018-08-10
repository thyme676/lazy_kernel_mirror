# lazy_kernel_mirror
2 scripts that mirror the ubuntu mainline kernels.  
Have the latest, bleeding edge, kernel at your fingertips!  
*Warning! RC kernels are unstable and not for production!*

# Requirements
aria2 must be installed.  
This script also assumes the mirror.sh script is run in a publicly readable html directory.

# Usage
This is 2 parts, a mirror.sh script (server) and a download script (client).  
Add the server script to a cron job to copy down the latest kernels from the Ubuntu mainline kernel repository.  
If you wish to only keep the latest kernel, I recommend clearing this directory a few times a day.  

Then run the client script on a laptop, or computer to download and install the latest RC kernel.
If the client script is run and it already has the latest kernel, aria will error and nothing will be changed.  
For convienence, the latest kernel is stored in file "latest"
