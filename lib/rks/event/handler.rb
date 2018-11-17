module RKS
  module Event
    class Handler
      include RKS::Support::Routable

      singleton_class.send(:alias_method, :call, :route)
    end
  end
end
