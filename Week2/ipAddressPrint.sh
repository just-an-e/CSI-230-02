#! /bin/sh
ip addr | grep inet | grep brd | cut -c 10-21

