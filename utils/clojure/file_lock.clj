(ns mindseal.file-lock
  (:import   
   [java.io IOException RandomAccessFile]
   [java.nio.channels FileChannel]
   [java.nio.channels FileLock]
   [java.nio.file Paths]
   [java.nio.file Path]
   [java.nio.file StandardOpenOption]
   ))

(defn mk-file-channel
  [filename]
  (let [file (RandomAccessFile. filename "rw")
        file-channel (.getChannel file)
        ]
    file-channel))

(defn trylock-file
  [filename]
  (let [file-channel (mk-file-channel filename)]
    (.tryLock file-channel)))

(defn lock-file
  [filename]
  (let [file-channel (mk-file-channel filename)]
    (.lock file-channel)))

(defn release-lock
  [file-lock]
  (.release file-lock))

(defn -main
  []
  (let [_ (println "try lock")
        lock (lock-file "/tmp/a")
        _ (if (nil? lock) (do (println "lock failed") (System/exit -1)) (println "add lock"))
        _ (Thread/sleep 10000)
        _ (println "try release")
        _ (if-not (nil? lock) (release-lock lock))
        lock (trylock-file "/tmp/a")
        _ (if (nil? lock) (do (println "lock failed") (System/exit -1)) (println "add lock"))
        _ (Thread/sleep 10000)
        _ (println "try release")
        _ (if-not (nil? lock) (release-lock lock))
        ]))
