(ns usemlib.core
  (:require [mlib.core :as mlib])
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!")
  (mlib/foo))
