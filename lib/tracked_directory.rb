class TrackedDirectory

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def ls(show_entries: nil, filter_by_extension: nil, filter_by_name: nil, sort_direction: :asc)
    entries = Dir.entries(@path)
    entries.delete(".")
    entries.delete("..")

    # тремя способами

    # 1(изначальный)
    # if show_entries == :files
    #   entries.delete_if { |i| !File.file?("#{@path}/#{i}") }
    # else show_entries == :dirs
    #   entries.delete_if { |i| File.file?("#{@path}/#{i}") }
    # end
    # entries

    # 2 вариант
    # entries.delete_if { |i| !File.file?("#{@path}/#{i}")} if show_entries == :files
    # entries.delete_if { |i| File.file?("#{@path}/#{i}")} if show_entries == :dirs
    # entries

    # 3 вариант
    # ["file1.txt", "dir1", "file2.txt"]
    #show_entries = :dirs
    entries.delete_if do |i|
      entry = (File.file?("#{@path}/#{i}") ? :files : :dirs)
      entry != show_entries
    end if [:dirs, :files].include?(show_entries)

    #sort by desc direction
    if sort_direction == :desc
      entries.sort! { |x,y| y <=> x }
    else
    #sort_by asc direction
      entries.sort
    end

    #filter_by_extension
    if filter_by_extension != nil
      entries = entries.select { |i| i =~/\.#{filter_by_extension}/ }
    end
    #filter_by_name
    entries = entries.select { |i| i =~/\A#{filter_by_name}/ }
    entries
  end
end
