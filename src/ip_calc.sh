#!/bin/bash

# Global vars
NET_ADDR=""
NET_MASK=""
BCAST_ADDR=""
IP_COUNT=""
EMPTY_SPACES='    '

ip_calc (){
    echo "|=====================================================|";
    echo "|                 IP CALCULATOR                       |";
    echo "|=====================================================|";
    EMPTY_SPACES="    ";
    if [ $(echo $1 | grep '/') ] > 0; then
        echo "Mascara com formato decimal";
        echo "Ainda não implementado";
        ip_calc_exit;
    else
        if [ -z $2 ]; then
            ip_calc_show_help;
        else
            ip_calc_network_calc $1 $2;
        fi;
    fi;
    echo "$EMPTY_SPACES Total of addresses: $IP_COUNT";
    echo "$EMPTY_SPACES Total of valid addresses: $(($IP_COUNT - 2))";
    echo "$EMPTY_SPACES Network address: $NET_ADDR";
    echo "$EMPTY_SPACES Broadcast address: $BCAST_ADDR";
    echo ""
}

ip_calc_exit (){
    set -e
}
#
# Calc IP network and broadcast address
# 
# $1 : IP Address
# $2 : Broadcast address
#
ip_calc_network_calc (){
    if [ -z $1 ] || [ -z $2 ]; then
        ip_calc_show_help;
    fi;
    first_ip="";
    last_ip="";
    for index in 1 2 3 4 ; do
        ip_o=$(echo $1 | cut -d'.' -f$index);
        mask_o=$(echo $2 | cut -d'.' -f$index);
        has_dot=".";
        net_o="";
        bcast_o="";
        bcast_o=$(($ip_o | (255 - $mask_o)));
        net_o=$(($ip_o & $mask_o));
        if [ $index = 4 ]; then
            has_dot="";
            first_ip=$net_o;
            last_ip=$bcast_o;
        else
            has_dot=".";
        fi;
        NET_ADDR=$NET_ADDR$net_o$has_dot;
        BCAST_ADDR=$BCAST_ADDR$bcast_o$has_dot;
    done;
    IP_COUNT=$(($last_ip - $first_ip))
}

ip_calc_show_help (){
    echo "Show help!"
}