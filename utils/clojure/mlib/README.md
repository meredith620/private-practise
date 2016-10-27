# mlib

A Clojure library designed to ... well, that part is up to you.

### lein publish method

* to private repository

https://github.com/technomancy/leiningen/blob/stable/doc/DEPLOY.md#static-http

~~~shell
lein deploy myrepo #<= repo name
~~~

* to clojars

https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md#publishing-libraries

~~~shell
lein deploy clojars
~~~


## Usage

* install mlib local repository

http://www.spacjer.com/blog/2015/03/23/leiningen-working-with-local-repository/

~~~shell
lein install
~~~

* in app's project.clj

:dependencies
~~~
[mlib "0.1.0-SNAPSHOT"]
~~~

FIXME

## License

Copyright © 2016 FIXME

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.



