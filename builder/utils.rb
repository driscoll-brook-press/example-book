def copies(from:, to:)
  sources = FileList[from / '**/*'].exclude { |f| Pathname(f).directory? }
  map = "%{^#{from}/,#{to}/}p"
  mapping(sources, map) do |source, target|
    cp source, target.pathmap('%d')
  end
end

def mapping(sources, map, &block)
  targets = sources.pathmap(map)
  sources.zip(targets).each do |source, target|
    mapped_file(source, target, &block)
  end
  targets
end

def mapped_file(source, target)
  target_dir = target.pathmap('%d')
  directory target_dir
  file target => [source, target_dir] do
    yield source, target
  end
end
