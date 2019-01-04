#!/bin/bash

wget "http://alephprod.library.nd.edu:8991/X?op=circ_status&library=NDU30&sys_no=000028389" -O ./incoming_status_info.xml && xmllint --format ./incoming_status_info.xml > ./sample_aleph_item_status.xml && rm ./incoming_status_info.xml
