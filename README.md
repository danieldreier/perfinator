# Perfinator

HTTP load testing and benchmarking tool with statsd output

This is intended as a replacement for [siege](http://www.joedog.org/siege-home/),
[apache bench](http://httpd.apache.org/docs/2.2/programs/ab.html), httperf, and
so on.

It takes a file containing a list of URLs, visits them programatically,
measures details about the connection time, and then sends that data to a
[StatsD](https://github.com/etsy/statsd/) endpoint.

rephrased from http://www.rubydoc.info/github/taf2/curb/Curl/Easy:
(to be clear, I haven't entirely figured out what these mean myself. You know as much as I do.)

`connect_time`:         time in seconds it took from the start until the
                        connect to the remote host (or proxy) was completed
`start_transfer_time`:  time in seconds it took from the start until the first
                        byte is just about to be transferred.
`name_lookup_time`:     time in seconds taken by DNS lookup
`pre_transfer_time`:    time in seconds it took from the start until the file
                        transfer is just about to begin
`redirect_time`:        time in seconds it took for all redirection steps
                        include name lookup, connect, pretransfer and transfer
                        before final transaction was started. redirect_time
                        contains the complete execution time for multiple
                        redirections.
`total_time`:           time in seconds for the transfer, including name
                        resolving, TCP connect etc.
`downloaded_bytes`:     total amount of bytes that were downloaded in the
                        preceeding transfer
`download_speed`:       average download speed that curl measured for the
                        preceeding complete download

## Installation

    $ gem install perfinator

## Usage

```bash
perfinator --help
Usage: perfinator [options]

HTTP load testing and benchmarking tool with statsd output

v0.0.1

Options:
    -h, --help                       Show command line help
    -s, --server STATSD_SERVER       StatsD server to send metrics to
                                     (default: localhost)
    -p, --port STATSD_PORT           StatsD port to send metrics to
                                     (default: 8125)
    -c, --concurrent NUM             Simulated concurrent users
                                     (default: 10)
    -n, --requests NUM               Number of requests to make during the test
                                     (default: 500)
    -d, --delay SECONDS              Time delay between requests by a given simulated user
                                     (default: 2)
    -f, --file FILE                  File containing URLs to get
        --version                    Show help/version info
        --log-level LEVEL            Set the logging level
                                     (debug|info|warn|error|fatal)
                                     (Default: info)
```

```bash
perfinator --file test_urls.txt --requests 100 --server statsd.example.com --delay 1
```

## Caveats
There are no tests and this was hacked together in a few hours. Nothing has
been validated and I'm not terribly confident that the metrics are accurate.

## Contributing

1. Fork it ( https://github.com/danieldreier/perfinator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
