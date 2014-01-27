class Environment

  def self.environment_name_in_plist
    NSBundle.mainBundle.objectForInfoDictionaryKey('environment').to_sym
  end

  def self.shared
    @shared ||= new(environment_name_in_plist, ENVIRONMENT_CONFIG)
  end

  def initialize(name, config)
    self.name = name
    self.original_name = name

    self.config = Hashie::Mash.new(config)
    self.runtime = Hashie::Mash.new
  end

  # if test? is true so is development?
  def test?
    RUBYMOTION_ENV == 'test'
  end

  def development?
    name == :development
  end

  def release?
    name == :release
  end

  def staging?
    name == :staging
  end

  def simulator?
    Device.simulator?
  end

  def development_certificate?
    has_certificate? && development?
  end

  def production_certificate?
    has_certificate? && (staging? || release?)
  end

  def has_certificate?
    !simulator?
  end

  def method_missing(method, *args, &block)
    if method[-1] == '='
      key = method[0..-2]
      self[key] = args.first
    elsif include? method
      self[method]
    else
      super
    end
  end

  def [](k)
    source_for(k)[k]
  end

  def []=(k, v)
    runtime[k] = v
  end

  def include? k
    sources.any? { |s| s.include? k }
  end

  def delete(k)
    runtime.delete k
  end

  attr_reader :name
  def name=(v)
    @name = v.to_sym
  end

  private

  attr_accessor :config, :runtime, :original_name

  def source_for(k)
    sources.find { |s| s.include? k } || {}
  end

  def sources
    [
        runtime,
        config[name],
        config
    ]
  end

end