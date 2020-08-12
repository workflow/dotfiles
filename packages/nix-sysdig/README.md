# nix-sysdig

Record/replay system calls of nix builds.

## Example

```console
$ cd nixpkgs/pkgs
# fake a failing build (to have more interesting traces)
$ git diff pkgs/development/python-modules/python-lz4/default.nix
diff --git a/pkgs/development/python-modules/python-lz4/default.nix b/pkgs/development/python-modules/python-lz4/default.nix
index a0fe6666d84..c558aad0de5 100644
--- a/pkgs/development/python-modules/python-lz4/default.nix
+++ b/pkgs/development/python-modules/python-lz4/default.nix
@@ -22,7 +22,7 @@ buildPythonPackage rec {
     sha256 = "1vjfplj37jcw1mf8l810dv76dx0raia3ylgyfy7sfsb3g17brjq6";
   };

-  buildInputs = [ setuptools_scm pkgconfig pytestrunner ];
+  buildInputs = [ setuptools_scm pkgconfig ];
   checkInputs = [ pytest psutil ];
   propagatedBuildInputs = lib.optionals (!isPy3k) [ future ];

$ nix-shell -p python3.pkgs.python-lz4 --builders ''
$ sudo nix-sysdig record python-lz4
$ sudo nix-sysdig replay ./python-lz4.scap 'fd.port = 53 and evt.type=sendto'
$ sudo nix-sysdig replay ./python-lz4.scap -- -c stderr
$ sudo nix-sysdig replay ./python-lz4.scap 'fd.name contains /etc and evt.type in (open, openat)'
```
