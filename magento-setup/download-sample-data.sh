#!/usr/bin/env bash
curl -s https://raw.githubusercontent.com/Vinai/compressed-magento-sample-data/1.9.1.0/compressed-magento-sample-data-1.9.1.0.tgz | tar -xvz -C sample-data
curl -s https://raw.githubusercontent.com/Vinai/compressed-magento-sample-data/1.9.0.0/compressed-magento-sample-data-1.9.0.0.tgz | tar -xvz -C sample-data
curl -s http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz | tar -xvz -C sample-data
curl -s http://www.magentocommerce.com/downloads/assets/1.1.2/magento-sample-data-1.1.2.tar.gz | tar -xvz -C sample-data