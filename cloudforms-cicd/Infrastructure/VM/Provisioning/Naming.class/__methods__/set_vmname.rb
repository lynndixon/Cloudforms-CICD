# define log method
def log(level, msg, update_message = false)
  $evm.log(level, "#{msg}")
  @task.message = msg if @task && (update_message || level == 'error')
end

begin
  # set method variables
  @method = $evm.current_method
  @task = $evm.root['service_template_provision_task']

  # Get vm and prob objects
  case $evm.root['vmdb_object_type']
  when 'vm'
    vm = $evm.root['vm'] || nil
    prov = vm.miq_provision || nil
    $evm.log(:info, "vmdb_object_type is: #{$evm.root['vmdb_object_type']}")
    if vm.nil?
      $evm.log(:info, "vm object can't be found, exiting!")
      exit MIQ_WARN
    end
  when 'miq_provision'
    prov = $evm.root['miq_provision_request'] rescue nil
    prov ||= $evm.root['miq_provision'] rescue nil
    prov ||= $evm.root['miq_provision_request_template'] rescue nil
    vm = prov.destination || nil
    $evm.log(:info, "vmdb_object_type is: #{$evm.root['vmdb_object_type']}")
    if prov.nil?
      $evm.log(:info, "prov object can't be found, exiting!")
      exit MIQ_WARN
    end
    $evm.log(:info, "prov object inspect is: #{prov.inspect}")
  end

  # collect the vm_name variable from our provisioning object

  log(:info, "prov object found is: #{prov.inspect} ")
  vm_name = nil
  vm_name = prov.get_option(:vm_target_name).to_s.strip
  vm_prefix = "TEST1" + $evm.object['vm_prefix']

  # Simple handler to generate a vmname if none is supplied by a service dialog or other means
  if vm_name.blank? || vm_name == 'changeme'
    log(:info, "seting name to use vm_prefix: #{vm_prefix}")
    prov.update_vm_name("#{vm_prefix}$n{3}")
  end

  exit MIQ_OK
rescue => err
  method = $evm.current_method
  error_guid = get_guid()
  log_failure(method, error_guid, err)

  # log exiting method and exit with MIQ_ABORT status
  $evm.log(:warn, "#{error_guid} : #{method} in ERROR aborting")
  exit MIQ_ABORT
end
