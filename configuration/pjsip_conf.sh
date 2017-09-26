#!/usr/bin/env bash

svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
mv trunk/ pjsip-project/
cd pjsip-project/pjlib/include/pj
touch config_site.h
echo "/*Activate Android specific settings in the 'config_site_sample.h'*/

#define PJ_CONFIG_ANDROID 1
#define PJ_HAS_SSL_SOCK 1
#include <pj/config_site_sample.h>" >> config_site.h
