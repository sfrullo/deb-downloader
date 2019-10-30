#!/bin/bash

version="${1:-16.04}"

sudo docker pull amd64/ubuntu:${version}
sudo docker pull i386/ubuntu:${version}