# lazy_kernel_mirror
2 scripts that mirror the ubuntu mainline kernels.
*Warning! RC kernels are unstable and not for production!*

# Usage
This is 2 parts, a mirror.sh script (server) and a download script (client).
Add the server script to a cron job to copy down the latest kernels from the Ubuntu mainline kernel repository.
If you wish to only keep the latest kernel, I recommend clearing this directory a few times a day.

Then run the client script on a laptop, or computer to download and install the latest RC kernel.
