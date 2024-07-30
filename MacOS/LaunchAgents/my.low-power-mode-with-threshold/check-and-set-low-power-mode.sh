#!/bin/bash

# Check that low power mode is enabled. If it's enabled, we exit as we rely
# on built-in MacOS settings to disable it when laptop is connected back to
# power source.
low_power_mode=$(pmset -g | grep lowpowermode | cut -w -f3)
echo Low Power Mode: $low_power_mode
[ $low_power_mode -gt 0 ] || exit

# Check the current battery percentage
battery_level=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
echo Battery Level: $battery_level

# Define the threshold percentage
threshold=50

# Check if the battery level is below the threshold
if [ "$battery_level" -lt "$threshold" ]; then
  # Enable low power mode
  sudo pmset -a lowpowermode 1
else
  # Disable low power mode
  sudo pmset -a lowpowermode 0
fi
