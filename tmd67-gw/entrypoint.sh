#!/bin/bash

service ssh start

echo "CMD["$@"]"
exec "$@"
