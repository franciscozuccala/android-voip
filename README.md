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
chmod +x openssl_conf.sh
./openssl_conf.sh
Insertar arm -> android-19 -> /path/to/android-ndk-r13b -> [/path/to/openssl-1.1.0c]
```
- Luego ejecutar:
```
chmod +x pjsip_conf.sh
./pjsip_conf.sh
Insertar armeabi-v7a -> android-19 -> /path/to/android-ndk-r13b -> /path/to/openssl-1.1.0c
```


Pasos Seguidos para logra buildear con openssl:
- Ejecutar en el root/configuration de este proyecto:
```
chmod +x openssl_conf.sh
./openssl_conf_old.sh
Insertar armv7a -> android-16 -> /path/to/android-ndk-r12b -> [/path/to/openssl-1.0.2k]
svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
cd trunk/
export ANDROID_NDK_ROOT=/path/to/android-ndk-r12b
TARGET_ABI=armeabi-v7a APP_PLATFORM=android-16 ./configure-android --use-ndk-cflags --with-ssl=/path/to/openssl-1.0.2k
make dep && make clean && make
cd pjsip-apps/src/swig/
make
```
