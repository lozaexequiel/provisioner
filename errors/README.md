# Errors

If you get the following error provisioning a VM:

~~~bash
cp: cannot stat '<PATH>'$'\r': No such file or directory
cp: cannot stat '<PATH>'$'\r': No such file or directory
~~~

It is likely that you have a carriage return in your path. This can happen if you copy and paste a path from a Windows machine. To fix this, you can use "dos2unix" to remove the carriage return. More information can be found in the [man pages](https://manpages.ubuntu.com/manpages/xenial/es/man1/dos2unix.1.html).

```dos2unix <PATH>```

Back to main [README](../README.md).

[//]: # (End of Path: errors\README.md)
