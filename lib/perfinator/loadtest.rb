module Perfinator
  class Loadtest
    require 'curb'
    require 'statsd-ruby'
    require 'parallel'

    include Methadone::CLILogging

    def self.run(statsd_server: 'localhost', statsd_port: 8125, concurrent: 10,
                requests: 500, delay: 2, statsd_namespace: 'perfinator',
                url_file: Nil, duration: 0)
      metrics_list = ['connect_time', 'start_transfer_time', 'name_lookup_time',
                      'pre_transfer_time', 'redirect_time', 'start_transfer_time',
                      'total_time', 'downloaded_bytes', 'download_speed']

      Parallel.map(1..requests, :in_threads => concurrent ) {
        statsd = Statsd.new statsd_server, statsd_port
        statsd.namespace = statsd_namespace
        metrics = Hash.new

        begin
          url = File.readlines(url_file).sample.chomp
          debug "requesting: #{url}"
          request = Curl::Easy.new(url)
          request.get
        rescue Curl::Err::HostResolutionError
          logger.error('cannot parse url: ' + url.to_s)
          break
        end
        statsd.increment 'requests'
        # see http://www.rubydoc.info/github/taf2/curb/Curl/Easy for what these mean
        for metric in metrics_list
          metrics[:"#{metric}"] = request.send(metric)
          statsd.timing metric, metrics[:"#{metric}"]
          debug "sent statsd metric: '#{metric}' with value " + metrics[:"#{metric}"].to_s
        end
        info "%5ss [%6s] %20s" % [metrics[:total_time].round(3), request.status, url.to_s]
      }
    end
  end
end
