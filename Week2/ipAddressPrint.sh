#!/bin/bash
ip addr | grep '10\.0\.2\.15/24' | awk '{print $2}'
