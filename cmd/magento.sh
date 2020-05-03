#!/bin/sh

./cmd/compose.sh exec -it backend-magento bin/magento $@
