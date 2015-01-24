module Perfinator
  class Loadtest
    require 'curb'
    require 'statsd-ruby'
    require 'parallel'
    require 'colorize'
    require 'ruby-progressbar'

    include Methadone::CLILogging

    def self.run(statsd_server: 'localhost', statsd_port: 8125, concurrent: 10,
                requests: 500, delay: 2, statsd_namespace: 'perfinator',
                url_file: Nil, verbose: false)
      metrics_list = ['connect_time', 'start_transfer_time', 'name_lookup_time',
                      'pre_transfer_time', 'redirect_time', 'start_transfer_time',
                      'total_time', 'downloaded_bytes', 'download_speed']

      Parallel.map(1..requests, :in_threads => concurrent) {
        statsd = Statsd.new statsd_server, statsd_port
        statsd.namespace = statsd_namespace
        metrics = Hash.new

        begin
          url = File.readlines(url_file).sample.chomp
        rescue
          logger.error("Unable to read from file: '#{url_file}'")
        end

        begin
          debug "requesting: #{url}"
          request = Curl::Easy.new(url)
          request.get
        rescue Curl::Err::HostResolutionError
          logger.error('cannot parse url: ' + url.to_s)
          break
        end
        debug 'incrementing "requests" statsd counter'
        statsd.increment 'requests'
        # see http://www.rubydoc.info/github/taf2/curb/Curl/Easy for what these mean
        for metric in metrics_list
          debug "sending statsd metric: '#{metric}' with value " + metrics[:"#{metric}"].to_s
          metrics[:"#{metric}"] = request.send(metric)
          statsd.timing metric, metrics[:"#{metric}"]
        end
        statsd.increment 'http_status.' + request.response_code.to_s
        debug 'sent statsd increment on http_status.' + request.response_code.to_s

        if $stdout.tty?
          case request.response_code.to_s
          when /^2\d{2}/
            color = :blue
          when /^3\d{2}/
            color = :light_green
          when /^4\d{2}/
            color = :light_red
          when /^5\d{2}/
            color = :red
          end
          request_status = request.status.colorize(color)
        else
          request_status = request.status
        end

        if verbose
          info "%5ss [%6s] %20s" % [metrics[:total_time].round(3), request_status, url.to_s]
        end
      }
    end
  end
end
