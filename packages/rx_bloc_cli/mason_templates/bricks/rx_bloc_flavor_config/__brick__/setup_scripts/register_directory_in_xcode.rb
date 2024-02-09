require 'xcodeproj'

if ARGV.length < 2 || ARGV.length > 3
  puts 'Wrong number of arguments arguments'
  exit
end

def add_dir_to_group(project_path, directory_path, group_name)
  project = Xcodeproj::Project.open(project_path)
  group = group_name.nil? ? project.main_group : project.groups.detect { |group| group.name == group_name }
  directory_reference = group.new_reference(directory_path)
  project.save
end

project_path = ARGV[0]
dir_path = ARGV[1]
destination = ARGV.length == 3 ? ARGV[2] : nil

add_dir_to_group(project_path,dir_path, destination)