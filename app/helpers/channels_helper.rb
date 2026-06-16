module ChannelsHelper
  def provider_options_for(method)
    Channel.providers_by_method(method).map { |name, handle| [name, handle] }
  end

  def credentials_fields_for(provider_handle, method)
    provider = Channel.providers.find { |p| p[:handle] == provider_handle }
    return [] unless provider
    provider.dig(:credentials, method.to_sym) || []
  end
end
