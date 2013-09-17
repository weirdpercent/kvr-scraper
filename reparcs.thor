class Reparcs < Thor                                                 # [1]
  package_name "Reparcs"                                             # [2]
  map "-T" => :list                                              # [3]
  
  desc "APP_NAME", "install one of the available apps"   # [4]
  method_options :force => :boolean, :alias => :string           # [5]
  def install(name)
    user_alias = options[:alias]
    if options.force?
      puts "forced action"
    end
    puts "action
  end
  
  desc "list [SEARCH]", "list all of the available apps, limited by SEARCH"
  def list(search="")
    # list
  end
end
