# frozen_string_literal: true

module Log
    # @return [Symbol] The log level, one of :debug, :info, :warn: error
    attr_accessor :log_level
    @log_level = :info

    #
    # Dispays a debug message
    #
    # @param [String] msg The message to log
    #
    # @return [void]
    #
    def self.debug(msg)
        @log_level ||= :info
        puts msg if [:debug].include? @log_level
    end

    #
    # Dispays an info message
    #
    # @param [String] msg The message to log
    #
    # @return [void]
    #
    def self.info(msg)
        @log_level ||= :info
        puts msg if [:debug, :info].include? @log_level
    end

    #
    # Dispays a warning message
    #
    # @param [String] msg The message to log
    #
    # @return [void]
    #
    def self.warn(msg)
        @log_level ||= :info
        puts msg if [:debug, :info, :warn].include? @log_level
    end

    #
    # Dispays an error message
    #
    # @param [String] msg The message to log
    #
    # @return [void]
    #
    def self.error(msg)
        @log_level ||= :info
        puts msg if [:debug, :info, :warn, :error].include? @log_level
    end
end