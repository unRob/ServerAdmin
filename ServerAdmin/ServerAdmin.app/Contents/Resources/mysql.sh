#!/bin/sh

#  mysql.sh
#  ServerAdmin
#
#  Created by Roberto Hidalgo on 6/22/11.
#  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.

echo "Mira, un salmón: $1";
sudo /usr/local/mysql/support-files/mysql.server $1 > /dev/null &
