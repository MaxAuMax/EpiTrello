# Add some sample tags to existing projects (if any)
if Project.any?
  puts "Creating sample tags for existing projects..."

  Project.first(3).each do |project|
    next if project.tags.any? # Skip if project already has tags

    # Create common tags for each project
    tags = [
      { name: "Urgent", color: "#ef4444" },
      { name: "Bug", color: "#f97316" },
      { name: "Feature", color: "#3b82f6" },
      { name: "Enhancement", color: "#8b5cf6" },
      { name: "Documentation", color: "#06b6d4" }
    ]

    tags.each do |tag_attrs|
      project.tags.create(tag_attrs)
      puts "  - Created tag '#{tag_attrs[:name]}' for project '#{project.name}'"
    end
  end

  puts "✓ Sample tags created successfully!"
else
  puts "No projects found. Create a project first, then run this seed again."
end
