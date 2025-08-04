#!/bin/bash

# Enable python 3.8
. /opt/rh/rh-python38/enable

# Enable devtoolset
. /opt/rh/devtoolset-"$RUNTIME_DEVTOOLSET_VERSION"/enable

# Execute the command passed to the container
exec "$@"
