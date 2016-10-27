# mlib

A Clojure library designed to ... well, that part is up to you.

### lein publish method

* to clojars

https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md#publishing-libraries

~~~shell
lein deploy clojars
~~~

* deploy to private repository

https://github.com/technomancy/leiningen/blob/stable/doc/DEPLOY.md#static-http

:project.clj
~~~
(defproject mlib "0.2.0-SNAPSHOT"
  ... ...
  :plugins [[org.apache.maven.wagon/wagon-ssh-external "2.6"]]
  :repositories [["local" "scp://localhost/home/meredith/workspace/cmlibs"]])
(cemerick.pomegranate.aether/register-wagon-factory!
 "scp" #(let [c (resolve 'org.apache.maven.wagon.providers.ssh.external.ScpExternalWagon)]
          (clojure.lang.Reflector/invokeConstructor c (into-array []))))
~~~

~~~shell
lein deploy myrepo #<= repo name
~~~

* manual install mlib to local repository

http://www.spacjer.com/blog/2015/03/23/leiningen-working-with-local-repository/

in mlib/
~~~shell
lein install
~~~

## Usage


* fetch lib from local private repository

assume the local private repository server is http://localhost:9999
in mapp's project.clj
~~~
:repositories {"local" {:url "file://localhost:9999/home/meredith/workspace/cmlibs" ;http service :releases {:checksum :ignore}}}
:dependencies [[org.clojure/clojure "1.8.0"]
                 [mlib "0.2.0-SNAPSHOT"]]
~~~

FIXME

## License

Copyright © 2016 FIXME

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.



