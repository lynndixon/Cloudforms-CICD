#   create_custom_attribute.rb
#   Original Author: Lynn Dixon <lynn@redhat.com>
#
#   Inputs: $evm.root['vm']
#   Service Dialog Inputs:  dialog_custom_attribute
#
#   Description: Sets a custom attribute on a VM using a value from a service dialog
#	This is a simple demonstration method.
#
# -------------------------------------------------------------------------------
#


# Define our methods:
def set_custom_attr(obj, attr_name, attr)
  $evm.log('info', "Setting Custom Attribute on #{obj.name}:")
  obj.custom_set(attr_name, attr)
end

def dump_root()
  $evm.log(:info, 'Begin $evm.root.attributes')
  $evm.root.attributes.sort.each { |k, v| $evm.log(:info, "\t Attribute: #{k} = #{v}") }
  $evm.log(:info, 'End $evm.root.attributes')
  $evm.log(:info, '')
end

def dump_object()
  $evm.log(:info, 'Begin $evm.object.attributes')
  $evm.object.attributes.sort.each { |k, v| $evm.log(:info, "\t Attribute: #{k} = #{v}") }
  $evm.log(:info, 'End $evm.object.attributes')
  $evm.log(:info, '')
end

dump_root()
dump_object()

# Get our objects and variables
vm = $evm.root['vm']
task = $evm.root['automation_task'] || nil
task_params = task.options[:parameters] rescue nil
if vm.blank?
  $evm.log('info', "VM not found in root, looking in task params...")
  vm = $evm.vmdb(:vm).find_by_id(task_params['vm_id'])
end
$evm.log('info', "Found vm of #{vm.name}")
attr_name = "CI/CD Demo Attribute #1"
attr = $evm.root['dialog_custom_attribute'] || task_params['attribute']

# Send the attribute name and attribute to be set on the VM
$evm.log('info', "Sending attributes for VM: #{vm.name}")
set_custom_attr(vm, attr_name, attr)

exit MIQ_OK


