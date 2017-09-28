# android-voip
Probando generar una librería con voip
ref https://trac.pjsip.org/repos/wiki/Getting-Started/Android

[Download_NDK](http://pnsurez.blogspot.com.ar/2015/07/download-android-ndk-tools.html)

[Download_Openssl](https://www.openssl.org/source/openssl-1.0.2k.tar.gz)

Usando android ndk12b, generando .so con armeabi-v7a

Para generar libcrypto.so y libssl.so (Librerías openssl):
Ref: https://stackoverflow.com/a/18577811
- Ejecutar en el root/configuration de este proyecto:
```
chmod +x openssl_conf.sh
./openssl_conf.sh
Insertar arm -> android-16 -> /path/to/android-ndk-r12b -> [/path/to/openssl-1.0.2k]
```
- Para generar app de ejemplo y libpjsua.so:
```
chmod +x pjsip_conf.sh
./pjsip_conf.sh
Insertar armeabi-v7a -> android-16 -> /path/to/android-ndk-r12b -> /path/to/openssl-1.0.2k
```

Pasos Seguidos para logra buildear con openssl para armv7a y android-16:
- Ejecutar en el root/configuration de este proyecto:
```
./openssl_conf_for_pjsip.sh
Insertar armv7a -> android-16 -> /path/to/android-ndk-r12b -> [/path/to/openssl-1.0.2k]
./pjsip.conf.sh
Insertar /path/to/android-ndk-r12b -> armeabi-v7a -> android-16 -> y -> /path/to/openssl-1.0.2k
```
- Luego agregar los .so a la carpeta jniLibs dentro de src/main/[architecture]
