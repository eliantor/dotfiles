{:user {:plugins [[lein-iclojure "1.1"]
                  [lein-ritz "0.6.0"]]
        :dependencies [[ritz/ritz-nrepl-middleware "0.6.0"]]
        :repl-options {:nrepl-middleware
                       [ritz.nrepl.middleware.javadoc/wrap-javadoc
                        ritz.nrepl.middleware.simple-complete/wrap-simple-complete]}
        :hooks [ritz.add-sources]}}