#!/usr/bin/env bash

echo -n "Changing ownership for current and parent directory..."
chown mitchell.music . .. || exit 1
echo "done."

echo -n "Ripping tracks from CD..."
cdparanoia -d /dev/scd0 -B 1- || exit 1
echo "done."

echo -n "Ejecting CD..."
eject /dev/scd0 || exit 1
echo "done."

echo -n "Changing ownership for wav files..."
chown mitchell.music *.wav || exit 1
echo "done."

echo "All done."
