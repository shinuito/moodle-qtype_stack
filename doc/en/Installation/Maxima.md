# Unicode support for Maxima

For unicode support the Maxima version must be 5.38.1 or later.  For unicode suppoprt the Maxima installation and the runtime environment it has matter.

You can test whether your server has working support for unicode from the healthcheck page: search the page for `unicode(8704)` and confirm the output.

If you use MaximaPool then the solution is typically simple, assuming that your server supports UTF-8 and it most likely does, just figure out where the environment settings of the Java-installation are or Tomcat or whatever, though those are typically by default UTF-8 already. Java will handle everything after one sets one single setting: https://github.com/maths/stack_util_maximapool/blob/multiple-pools/doc/encoding.txt

If not using MaximaPool then one needs to adjust the runtime environment of the web-server, apache or any other. They typically by default execute in ANSI-C locale (or no locale at all as empty environments are nice) if no one defines otherwise, they could also execute in non-unicode multi-byte encodings if the country they reside in need large character sets before unicode became the global solution, which is a common problem outside the anglo-centric world. We suggest that changes should happen outside STACK by setting up the server to operate in UTF-8.

Trouble shooting.

1. At the command line on the severver, start Maxima and issue the command `unicode(8704);` which will test if your version of Maxima has unicode support at all.
2. Check the value of `default_charset` in php.ini is `UTF-8`. (In Moodle, go to Site administration > Server > PHP info).
3. On a Debian server you can check which encodings/locale-settings are available using `locale -a` and you can add/generate addition settings on the server as root user.  You should have both `C` and `C.UTF-8`,and you should have something like `en_GB.UTF-8`. Note, it really does not need to be `en_GB`,  there are encodings/locale-settings and as long as they have UTF-8 in the name all should work (untested). Of course no matter what the locale defined it needs to be present in the system, so you may need to install a locale to get it working.


# Compiling Maxima from source.

As of 21st Dec 2015 the following has been used to compile Maxima from source.

### You will need the following, and GNU autotools 

    sudo apt-get install texinfo

### Download and compile SBCL (Lisp)

    cd /home/sangwinc/src
    wget http://downloads.sourceforge.net/project/sbcl/sbcl/1.3.1/sbcl-1.3.1-source.tar.bz2
    tar -xf sbcl-1.3.1-source.tar.bz2
    cd sbcl-1.3.1/
    ./make-config.sh
    ./make.sh

    sudo ./install.sh

### Download and compile Maxima

    cd /home/sangwinc/src
    wget http://kent.dl.sourceforge.net/project/maxima/Maxima-source/5.36.1-source/maxima-5.36.1.tar.gz
    tar -zxf maxima-5.36.1.tar.gz
    cd maxima-5.36.1/

    ./configure  --with-sbcl

    make
    sudo make install


