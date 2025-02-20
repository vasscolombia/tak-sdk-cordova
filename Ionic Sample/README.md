# Ionic Sample

Proyecto de Ionic Cordova de ejemplo de uso de TakPlugin

## Instalacion Plugin TakPlugin

Es necesario disponer del plugin TakPlugin y de un entorno virtual de Python que sea capaz de ejecutar el script `encrypt_resource_file.py`.

### Paso 0: Crear entorno virtual de Python

```
$ python3 -m venv /path/to/new/virtual/environment
$ /path/to/new/virtual/environment/bin/pip3 install pycryptodomex
```

### Paso 1: Añadir plugin al proyecto

```
$ ionic cordova plugin add /ruta/al/plugin/TakPlugin
```

Es necesario definir un valor correcto para las variables siguientes en el script `hooks/after_prepare.js`:
* `pyvenv_root`: acorde a lo definido en el paso #0
* `tak_root`: debe apuntar a la raíz de la delivery completa de TAK. Concretamente, la ruta `${tak_root}/tools/FileProtector/script/encrypt_resource_file.py` debe apuntar al script Python esperado.

También es importante definir, en `plugin.xml`, que ficheros se desean encriptar usando los campos `<include>` y `<exclude>` dentro de `<cryptfiles>`.

### Paso 2: Añadir plataformas

```
$ ionic cordova platform add android
$ ionic cordova platform add ios

$ ionic cordova build android
$ ionic cordova build ios
```

### Paso 3: Configurar proyectos nativos

Abrir los IDEs nativos y seguir los pasos de instalacion de librerias y licencias.
