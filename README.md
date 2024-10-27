# samsung_root_ota_update

## Downloading firmware

You can open this in Gitpod or GitHub Codespaces and process the firmware files there before downloading to your PC.

Run `./startc.sh <your-csc> <your-model> <your-iemi>`.

Example: `./startc.sh EVR SM-S928B 123456789012345` (not real IMEI BTW, use your own)

Once you're in the bash shell, you can run `down` command to directly download the latest firmware package for your device. It will be saved in `./download` directory.

There's also another shortcut command called `up`, which will only give you the latest firmware version string.

## Update protocols I follow

Having a backup protocol in place is must unless your data and time is worthless. If something goes wrong after update, you could easily restore your previous device state.

- Trigger manual Samsung cloud + Google backup
- "Full" device backup using `Smart Switch (Desktop)`
- Optionally, I may backup certain apps using `App Manager` (fdroid)

## How I flash/update S24 Ultra using Heimdall

I don't own a Windows machine, I felt quite helpless due to the lack of proper/updated information online for anything other than Windows, and of course, Odin.

You can use Heimdall if you're on Mac or Linux but you need to know what you're doing.

Here's what I do, I might put this together in a more sophisticated script someday:

```bash
# Extract the main archive
unzip filename.zip

# Create separate directories
mkdir AP BL CP CSC_OXM HOME_CSC_OXM

tar -C AP the-ap.tar.md5
tar -C BL the-bl.tar.md5
tar -C CSC_OXM the-csc.tar.md5
tar -C HOME_CSC_OXM the-home_csc.tar.md5
lz4 --rm -dm AP/* BL/* CP/* CSC_OXM/* HOME_CSC_OXM/*


# Move out the pit file
# The filename will be different for you obviously
# You can decode the pit using `heimdall print-pit --file name-here > decoded.pit`
# Then you can map the `HOME_CSC_OXM/meta-data/download-list.txt` with your extracted files to figure out which partitions to flash for an update that doesn't wipe your data. It's mapped this way: download-list.txt > local-file > decoded.pit partition name.
# I've included an automated script (find.sh) that does the mapping for you and prints out a usable command for heimdall that you can copy and run.
# Place `find.sh` on the directory where you have your AP, CP... dirs. You may need to modify the `$opit` variable.
mv CSC_OXM/E3Q_EUR_OPENX.pit .

# If you're updating S24 ULTRA, it can look something like this.
# For keeping your data, usually you need to exclude misc, persist and userdata.
# At least, that's what I saw in `HOME_CSC_OXM/meta-data/download-list.txt`
/Applications/heimdall-frontend.app/Contents/MacOS/heimdall flash --APNHLOS BL/NON-HLOS.bin --XBL_RAMDUMP BL/XblRamdump.elf --ABL BL/abl.elf --AOP BL/aop.mbn --AOP_CONFIG BL/aop_devcfg.mbn --APDP BL/apdp.mbn --BKSECAPP BL/bksecapp.mbn --CPUCP BL/cpucp.elf --CPUCP_DTB BL/cpucp_dtbs.elf --DEVCFG BL/devcfg.mbn --DSP BL/dspso.bin --EM BL/engmode.mbn --HYP BL/hypvm.mbn --IMAGEFV BL/imagefv.elf --KEYMASTER BL/keymint.mbn --TOOLSFV BL/quest.fv --QUPFW BL/qupv3fw.elf --SECDATA BL/sec.elf --SHRM BL/shrm.elf --STORSEC BL/storsec.mbn --TZ BL/tz.mbn --HDM BL/tz_hdm.mbn --TZICCC BL/tz_iccc.mbn --TZ_KG BL/tz_kg.mbn --UEFI BL/uefi.elf --UEFISECAPP BL/uefi_sec.mbn --VK BL/vaultkeeper.mbn --VBMETA BL/vbmeta.img --XBL_CONFIG BL/xbl_config.elf --XBL BL/xbl_s.melf --BOOT AP/boot.img --DTBO AP/dtbo.img --INIT_BOOT AP/init_boot.img --RECOVERY AP/recovery.img --SUPER AP/super.img --VBMETA_SYSTEM AP/vbmeta_system.img --VENDOR_BOOT AP/vendor_boot.img --VM-BOOTSYS AP/vm-bootsys.img --MODEM CP/modem.bin --CACHE HOME_CSC_OXM/cache.img --OPTICS HOME_CSC_OXM/optics.img --PRISM HOME_CSC_OXM/prism.img
```

## Notes for me

- s24 ultra EVR changelog: https://doc.samsungmobile.com/SM-S928B/EVR/doc.html