require "forwardable"

Producer = Struct.new(:name, :producer) do
  extend Forwardable
  
  def_delegators :producer, :call
end
