(defproject mlib "0.2.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]]
  :plugins [[org.apache.maven.wagon/wagon-ssh-external "2.6"]]
  :repositories [["local" "scp://localhost/home/meredith/workspace/cmlibs"]])

(cemerick.pomegranate.aether/register-wagon-factory!
 "scp" #(let [c (resolve 'org.apache.maven.wagon.providers.ssh.external.ScpExternalWagon)]
          (clojure.lang.Reflector/invokeConstructor c (into-array []))))
