require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: gitify [options]"

  opts.on("-n", "--namespace=NAMESPACE", "Define the namespace of the repository") do |namespace|
    options[:namespace] = namespace
  end

  opts.on("-g", "--git=REPOSITORY", "Define the repository.git | Example: --git=test.git") do |git|
    options[:git] = git
  end

  opts.on("-a", "--all", "Provision all branches. (Staging, Acc, Production, Master)") do |v|
        options[:all] = v
  end

  opts.on("-br", "--branche=BRANCHES", "Branches split by a ,") do |branches|
        options[:branches] = branches
  end

  opts.on("-p", "--projecttype=TYPE", "Type: drupal(didi) or general (capistano)") do |type|
      options[:type] : type
  end

  opts.on("-d", "--directory=DIRECTORY", "The place where gitify has to create your structure") do |dir|
      options[:dir] = dir
  end
end.parse!

p options


if options[:all] == true
  #do something
elsif options[:branches].length > 0
  #dosomething
else
  #dosomething
end

output_git_clone = `git clone git@gitlab.crosscheck.be:#{options[:git]}`

if output_git_clone.include? "done"

    output_projectify_master = ` cd #{options[:git].chop.chop.chop.chop};projectify #{options[:type]} #{options[:dir]}`
    output_projectify_staging = `git branch staging;git checkout staging;git push origin staging`
    output_projectify_production = `git branch production;git checkout production;git push origin production`
    output_projectify_acc = `git branch acc;git checkout acc;git push origin acc`

end
