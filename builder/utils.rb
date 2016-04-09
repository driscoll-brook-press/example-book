def copies(from:, to:)
  sources = FileList[from / '**/*'].exclude { |f| Pathname(f).directory? }
  targets = sources.pathmap("%{^#{from}/,#{to}/}p")
  targets.zip(sources).each do |target, source|
    target_dir = target.pathmap('%d')
    directory target_dir
    file target => [source, target_dir] do |t|
      cp t.source, target_dir
    end
  end
  targets
end
