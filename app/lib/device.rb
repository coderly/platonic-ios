class Device
  extend self

  def self.shared
    @shared ||= new
  end

  def key
    UIDevice.currentDevice.identifierForVendor.UUIDString
  end

  def app_version
    NSBundle.mainBundle.infoDictionary['CFBundleVersion']
  end

  def environment_name
    Environment.shared.name
  end

  def os_name
    'ios'
  end

  def os_version
    UIDevice.currentDevice.systemVersion
  end

  def carrier_name
    phone_info = CTTelephonyNetworkInfo.new
    carrier = phone_info.subscriberCellularProvider
    carrier ? carrier.carrierName : nil
  end

  def model_name
    GBDeviceInfo.rawSystemInfoString
  end

  def to_hash
    {
        key: key,
        app_version: app_version,
        os_name: os_name,
        os_version: os_version,
        carrier_name: carrier_name,
        model_name: model_name,
        environment_name: environment_name
    }
  end

end