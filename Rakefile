
# This Rakefile has all the right settings to run the tests inside each lab


task :default => :test


task :test do
	ruby "#{ARGV.last}.rb"
	task ARGV.last.to_sym do #empty task to prevent rake from trying to run the command line argument as a  
	end
end