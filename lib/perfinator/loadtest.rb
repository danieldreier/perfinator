module Perfinator
  class Loadtest
    require 'curb'
    require 'statsd-ruby'
    require 'parallel'
    require 'ruby-progressbar'
    include Methadone::CLILogging

    def self.run(statsd_server: 'localhost', statsd_port: 8125, concurrent: 10,
                requests: 500, delay: 2, url_file: Nil)
      metrics_list = ['connect_time', 'start_transfer_time', 'name_lookup_time',
                      'pre_transfer_time', 'redirect_time', 'start_transfer_time',
                      'total_time', 'downloaded_bytes', 'download_speed']

      Parallel.map(1..requests, :in_threads => concurrent, :progress => "Load Testing") {
        statsd = Statsd.new statsd_server, statsd_port
        metrics = Hash.new

        begin
          url = File.readlines(url_file).sample.chomp
          info "requesting: #{url}"
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
      }
    end
  end
end
