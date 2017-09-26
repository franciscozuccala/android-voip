# android-voip
Probando generar una librería con voip
ref https://trac.pjsip.org/repos/wiki/Getting-Started/Android

[Download_NDK](http://pnsurez.blogspot.com.ar/2015/07/download-android-ndk-tools.html)

[Download_Openssl](https://www.openssl.org/source/openssl-1.1.0c.tar.gz)

Usando android ndk13r, generando .so con armeabi-v7a

Para generar openssl:
Ref: https://stackoverflow.com/a/18577811
- Ejecutar en el root/configuration de este proyecto:
```
tar xzvf ~/Downloads/openssl-1.1.0c.tar.gz
chmod +x openssl_conf.sh
./openssl_conf.sh
Insertar arm -> android-19 -> /path/to/android-ndk-r13b -> /path/to/openssl-1.1.0c
```

Pasos seguidos (Es necesario tener instalado svn):
- svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
- cd trunk/
- Crear archivo config_site.h en /pjlib/include/pj que tenga:
```
/*Activate Android specific settings in the 'config_site_sample.h'*/

#define PJ_CONFIG_ANDROID 1
#define PJ_HAS_SSL_SOCK 1
#include <pj/config_site_sample.h>
```
- export ANDROID_NDK_ROOT=/path_to_android_ndk13b_dir
- TARGET_ABI=armeabi-v7a APP_PLATFORM=android-19 ./configure-android --use-ndk-cflags --with-ssl=/dir/to/openssl-1.1.0c
- make dep && make clean && make
- cd pjsip-apps/src/swig && make
