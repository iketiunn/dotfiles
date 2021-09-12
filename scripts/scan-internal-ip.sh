#!/bin/bash
for ip in 192.168.1.{1..254}; do
  arp -d $ip #> /dev/null 2>&1
  ping -c 1 $ip #> /dev/null 2>&1 &
done

wait

arp -na | grep -v incomplete
