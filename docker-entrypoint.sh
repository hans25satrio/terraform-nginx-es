#!/bin/bash

/usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3

exec /usr/local/bin/docker-entrypoint.sh elasticsearch
