#!/bin/bash

# Script to add comment system files to Xcode project

echo "Adding comment system files to VybeMVP.xcodeproj..."

# Add Comment model
xcrun xcodebuild -project VybeMVP.xcodeproj \
  -target VybeMVP \
  -configuration Debug \
  -quiet \
  build \
  OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies"

# Use ruby script to add files to project
ruby -e "
require 'xcodeproj'

project_path = 'VybeMVP.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find the target
target = project.targets.find { |t| t.name == 'VybeMVP' }

# Find the Social groups
features_group = project.main_group.find_subpath('Features', true)
social_group = features_group.find_subpath('Social', true)

# Create or find subgroups
models_group = social_group.find_subpath('SocialModels', true) || social_group.new_group('SocialModels')
views_group = social_group.find_subpath('SocialViews', true) || social_group.new_group('SocialViews')
managers_group = social_group.find_subpath('SocialManagers', true) || social_group.new_group('SocialManagers')

# Add files if they don't already exist in project
files_to_add = [
  { path: 'Features/Social/SocialModels/Comment.swift', group: models_group },
  { path: 'Features/Social/SocialManagers/CommentManager.swift', group: managers_group },
  { path: 'Features/Social/SocialViews/CommentsView.swift', group: views_group },
  { path: 'Features/Social/SocialViews/CommentCardView.swift', group: views_group }
]

files_to_add.each do |file_info|
  file_path = file_info[:path]
  group = file_info[:group]
  
  # Check if file already exists in project
  existing_ref = project.files.find { |f| f.real_path.to_s.end_with?(file_path) }
  
  unless existing_ref
    file_ref = group.new_reference(file_path)
    target.add_file_references([file_ref])
    puts \"Added: #{file_path}\"
  else
    puts \"Already exists: #{file_path}\"
  end
end

project.save
puts 'Project updated successfully!'
"

echo "✅ Comment system files added to Xcode project" 