module ManagedServicesRollup

  @queue = :event_rollup

  def self.perform(event_id)
    Event.find(event_id).do_managed_services_rollup
  end
end