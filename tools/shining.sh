# Kernel selection function
choose_kernel() {
  ui_print " "
  ui_print "Kernel Version Selection:"
  ui_print " "
  ui_print "  VOL + : Vanilla variant"
  ui_print "  VOL - : KSU variant"
  ui_print " "
  ui_print "Waiting for input... "
  ui_print " "
  ui_print " "

  while true; do
    input=$(getevent -qlc 1 2>/dev/null | grep -E "KEY_VOLUME(UP|DOWN)")
    case "$input" in
      *KEY_VOLUMEUP*)
        return 1
        ;;
      *KEY_VOLUMEDOWN*)
        return 2
        ;;
    esac
    sleep 0.1
  done
}

# Handle kernel selection
if [ -f "$AKHOME/Image.ksu" ] && [ -f "$AKHOME/Image.noksu" ]; then
  choose_kernel
  case $? in
    1)
      ui_print " "
      ui_print "Selected: Vanilla variant Kernel"
      mv -f "$AKHOME/Image.noksu" "$AKHOME/Image"
      ;;
    2)
      ui_print " "
      ui_print "Selected: KSU variant Kernel"
      mv -f "$AKHOME/Image.ksu" "$AKHOME/Image"
      ;;
  esac
elif [ -f "$AKHOME/Image" ]; then
  ui_print " "
  ui_print "Single image kernel found, flashing it"
  mv -f "$AKHOME/Image.ksu" "$AKHOME/Image"
elif [ -f "$AKHOME/Image.ksu" ]; then
  ui_print " "
  ui_print "Only KernelSU variant version found, flashing it"
  mv -f "$AKHOME/Image.ksu" "$AKHOME/Image"
elif [ -f "$AKHOME/Image.noksu" ]; then
  ui_print " "
  ui_print "Only Vanilla variant version found, flashing it"
  mv -f "$AKHOME/Image.noksu" "$AKHOME/Image"
fi

# boot install
if [ -L "/dev/block/bootdevice/by-name/init_boot_a" -o -L "/dev/block/by-name/init_boot_a" ]; then
    split_boot # for devices with init_boot ramdisk
    flash_boot # for devices with init_boot ramdisk
else
    dump_boot # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
    write_boot # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
fi
## end boot install
