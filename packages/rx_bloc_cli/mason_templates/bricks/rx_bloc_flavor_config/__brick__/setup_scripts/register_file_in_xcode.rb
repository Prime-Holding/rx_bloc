require 'xcodeproj'

if ARGV.length < 3 || ARGV.length > 4
  puts 'Wrong number of arguments arguments'
  exit
end

def add_file_to_folder(project_path, file_path, folder_name)
  if folder_name.nil?
    return
  end

  project = Xcodeproj::Project.open(project_path)
  target_folder = project.main_group.find_subpath(folder_name, true)
  file_reference = target_folder.new_file(file_path)
  project.save
end

def add_file_to_group(project_path, file_path, group_name)
  project = Xcodeproj::Project.open(project_path)

  group = group_name.nil? ? project.main_group : project.groups.detect { |group| group.name == group_name }
  file = group.find_file_by_path(file_path)
  if file.nil?
    file = group.new_reference(ARGV[1])
    project.targets[0].resources_build_phase.add_file_reference(file)
    project.save
   end
end

project_path = ARGV[0]
is_folder = ARGV[1] =~ /^(true|yes|y|1)$/i ? true : false
file_path = ARGV[2]
destination = ARGV.length == 4 ? ARGV[3] : nil

if is_folder
    # Adding to folder
    add_file_to_folder(project_path,file_path, destination)
else
    # Adding to xcode group
    add_file_to_group(project_path,file_path, destination)
end