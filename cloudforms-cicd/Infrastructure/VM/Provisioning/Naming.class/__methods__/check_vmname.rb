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

  # define log method
  def log(level, msg, update_message = false)
    $evm.log(level, "#{msg}")
    @task.message = msg if @task && (update_message || level == 'error')
  end
  
  def dump_root()
  log(:info, 'Begin $evm.root.attributes')
  $evm.root.attributes.sort.each { |k, v| log(:info, "\t Attribute: #{k} = #{v}") }
  log(:info, 'End $evm.root.attributes')
  log(:info, '')
  end
  
  def dump_object()
  log(:info, 'Begin $evm.object.attributes')
  $evm.object.attributes.sort.each { |k, v| log(:info, "\t Attribute: #{k} = #{v}") }
  log(:info, 'End $evm.object.attributes')
  log(:info, '')
  end


  # =======================
  # Begin Main Method
  # =======================
  
  # Set and get variables
  dump_root()
  dump_object()
  
  vm_prefix = $evm.object['vm_prefix']
  vm_name = vm.name

  # Check that the VM name includes the proper accepted naming scheme

  log(:info, "Checking VM name")
  if vm_name.starts_with?(vm_prefix)
    log(:info, "VM Name of #{vm_name} has proper prefix!", true)
  else
    log(:error, "VM Name DOES NOT have the proper prefix. Should be prefixed with #{vm_prefix}. VM Name is #{vm.name}", true)
    exit MIQ_ABORT
  end
  
  exit MIQ_OK
rescue => err
  method = $evm.current_method

  # log exiting method and exit with MIQ_ABORT status
  $evm.log(:warn, "#{method} in ERROR aborting")
  exit MIQ_ABORT
end
