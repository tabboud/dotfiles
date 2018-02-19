#!/usr/bin/env bash

# For default behavior
setDefaults() {
  pmset_on=0
  output_tmux=1
  ascii=0
  ascii_bar='=========='
  good_color="1;32"
  middle_color="1;33"
  warn_color="0;31"
  connected=0
  battery_path=/sys/class/power_supply/BAT0
}

setDefaults

battery_charge() {
    case $(uname -s) in
        "Darwin")
            if ((pmset_on)) && hash pmset 2>/dev/null; then
                if [ "$(pmset -g batt | grep -o 'AC Power')" ]; then
                    BATT_CONNECTED=1
                else
                    BATT_CONNECTED=0
                fi
                BATT_PCT=$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)
            else
                while read key value; do
                    case $key in
                        "MaxCapacity")
                            maxcap=$value;;
                        "CurrentCapacity")
                            curcap=$value;;
                        "ExternalConnected")
                            if [ $value == "No" ]; then
                                BATT_CONNECTED=0
                            else
                                BATT_CONNECTED=1
                            fi
                        ;;
                        esac
                    if [[ -n "$maxcap" && -n $curcap ]]; then
                        BATT_PCT=$(( 100 * curcap / maxcap))
                    fi
                done < <(ioreg -n AppleSmartBattery -r | grep -o '"[^"]*" = [^ ]*' | sed -e 's/= //g' -e 's/"//g' | sort)
            fi
            ;;
        "Linux")
            case $(cat /etc/*-release) in
                *"Arch Linux"*)
                    battery_state=$(cat $battery_path/energy_now)
                    battery_full=$battery_path/energy_full
                    battery_current=$battery_path/energy_now
                    ;;
                *)
                    battery_state=$(cat $battery_path/status)
                    battery_full=$battery_path/charge_full
                    battery_current=$battery_path/charge_now
                    ;;
            esac

            if [ $battery_state == 'Discharging' ]; then
                BATT_CONNECTED=0
            else
                BATT_CONNECTED=1
            fi
			now=$(cat $battery_current)
			full=$(cat $battery_full)
			BATT_PCT=$((100 * $now / $full))
            ;;
    esac
}

# Apply the correct color to the battery status prompt
apply_colors() {
    # Green
    if [[ $BATT_PCT -ge 75 ]]; then
        COLOR="#[fg=$good_color]"
    # Yellow
    elif [[ $BATT_PCT -ge 25 ]] && [[ $BATT_PCT -lt 75 ]]; then
        COLOR="#[fg=$middle_color]"
    # Red
    elif [[ $BATT_PCT -lt 25 ]]; then
        COLOR="#[fg=$warn_color]"
    fi
}

print_status() {
    printf "%s%s %s%s" "$COLOR" "[$BATT_PCT%]" "#[default]"
}

output_tmux=1
good_color="green"
middle_color="yellow"
warn_color="red"
battery_charge
apply_colors
print_status
