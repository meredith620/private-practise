(defproject mapp "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :repositories {"local" {; :url "file://home/meredith/workspace/cmlibs"
                          :url "http://localhost:9999/cmlibs"
                          }}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [mlib "0.2.0-SNAPSHOT"]]
  :main ^:skip-aot mapp.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
