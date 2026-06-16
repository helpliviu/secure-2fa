module ProjectsHelper
  def delivery_method_options
    Channel.delivery_methods.map { |m| [m.capitalize, m] }
  end

  def expiration_options
    [[" 1 minute",  60], ["2 minutes", 120], ["5 minutes", 300],
     ["10 minutes", 600], ["15 minutes", 900], ["30 minutes", 1800]]
  end
end
