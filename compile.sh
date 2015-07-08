gcc -c -fPIC eso.c -lGL -lSDL2
gcc -o libengine.so -shared -Wl,-soname,libengine.so eso.o -lGL -lSDL2
chmod 777 libengine.so
mv libengine.so /usr/local/lib/
