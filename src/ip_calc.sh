#!/bin/bash

#
# Calc IP network and broadcast address
# 
# $1 : IP Address
# $2 : Broadcast address
#
ip_calc_network_calc (){
    NET_ADDR=""
    NET_MASK=""
    BCAST_ADDR=""
    IP_COUNT=""

    if [ -z "$1" ] || [ -z "$2" ]; then
        ip_calc_show_help
    else 
        first_ip=""
        last_ip=""
        for index in 1 2 3 4 ; do
            ip_o=$(echo $1 | cut -d'.' -f$index)
            mask_o=$(echo $2 | cut -d'.' -f$index)
            has_dot="."
            net_o=""
            bcast_o=""
            bcast_o=$(($ip_o | (255 - $mask_o)))
            net_o=$(($ip_o & $mask_o))
            if [ $index = 4 ]; then
                has_dot=""
                first_ip=$net_o
                last_ip=$bcast_o
            else
                has_dot="."
            fi
            NET_ADDR=$NET_ADDR$net_o$has_dot
            BCAST_ADDR=$BCAST_ADDR$bcast_o$has_dot
        done
        IP_COUNT=$(($last_ip - $first_ip))
        # Show result
        echo "  Total of addresses: $IP_COUNT"
        echo "  Total of valid addresses: $(($IP_COUNT - 2))"
        echo "  Network address: $NET_ADDR"
        echo "  Broadcast address: $BCAST_ADDR"
        echo ""          
    fi
}

ip_calc_show_help (){
    echo "usage: "
    echo "  ipcalc ip_address[ /decimal_netmask | doted_netmask ] "
    echo "Ex: "
    echo ""
    echo "  ipcalc 192.168.0.3/24"
    echo "  ipcalc 192.168.0.3 255.255.255.0"
    echo ""
}

ip_calc (){

    echo "ipcalc"

    if [ $(echo $1 | grep '/' | wc -l ) -gt 0 ] ; then
        echo "WARNING: "
        echo "  Mascara com formato decimal"
        echo "  Ainda não implementado"
        echo ""
        ip_calc_show_help
    else
        if [ -z "$2" ]; then
            ip_calc_show_help
        else
            ip_calc_network_calc $1 $2
        fi
    fi
}